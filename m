Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaLWONO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:13:14 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36252 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbaLWONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:13:13 -0500
Message-ID: <54997875.5070607@acm.org>
Date: Tue, 23 Dec 2014 08:13:09 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Question about the function,ipmi_release in ipmi_devinf.c
References: <54974BAA.9020107@gmail.com>
In-Reply-To: <54974BAA.9020107@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2014 04:37 PM, nick wrote:
> Greetings Again Corney,
> Hope you are looking forward to the holidays. I am one question, about the function in my message.
> /* FIXME - free the messages in the list. */, is in this function I am wondering is this needed?
> Further more the only reason I can see for it is if we are to free the linked list of files or 
> inodes passed to the function, otherwise it's invalid. Please let me known if should sent in 
> a patch to remove it or add a for_each_through linked list call that deletes each file or inode
> in the list passed.

The recv_msgs list needs to be cleaned up in this case.  Basically, just
call ipmi_free_recv_msg()
on every message in the list.  A patch would be appreciated.

Thanks,

-corey


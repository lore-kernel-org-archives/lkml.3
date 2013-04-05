Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163084Ab3DEXsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 19:48:08 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49518 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162968Ab3DEXsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 19:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130405220156.GC31680@kroah.com>
References: <515E85C5.7010706@asianux.com>
	<20130405220156.GC31680@kroah.com>
Date: Fri, 5 Apr 2013 16:48:05 -0700
Message-ID: <CAMP5Xgd=wVrDVCc84L2kMk9ADy7avokB6D=4+kdAm8jF+NLVyg@mail.gmail.com>
Subject: Re: [PATCH] Staging: Android: looping issue, need break when get
 value firstly.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chen Gang <gang.chen@asianux.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Mirsal Ennaime <mirsal@mirsal.fr>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 3:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Apr 05, 2013 at 04:05:25PM +0800, Chen Gang wrote:
>>
>>   need break when 'target_thread' get value, firstly.
>>
>>     'tmp' is a stack (thread->transaction_stack),
>>     if 'proc' was the same between child node and parent node,
>>     the child would have higher priority than parent.
>
> Are you sure about this?
>
> have you tested it?
>

Theoretically this should not change the behavior. The purpose of this
code it to make sure only thread per process is part of a transaction
stack, so if it finds more than one transaction with a matching
process, they should all point to the same thread object. I think a
better change description is needed though.

--
Arve Hjønnevåg

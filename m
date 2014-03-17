Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaCQNCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932824AbaCQNCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:02:08 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: race in audit_log_untrusted_string for task_struct::comm
Date: Mon, 17 Mar 2014 09:01:45 -0400
Message-ID: <4829575.y6dA3xFjkS@x2>
Organization: Red Hat
User-Agent: KMail/4.12.3 (Linux/3.13.6-200.fc20.x86_64; KDE/4.12.3; x86_64; ; )
In-Reply-To: <20140315232846.GE27244@madcap2.tricolour.ca>
References: <20140315232846.GE27244@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 15, 2014 07:28:46 PM Richard Guy Briggs wrote:
> I'm inclined to go get_task_comm() in all 5 locations, but if we care
> more about locking overhead, I'll switch to memcpy().
> 
> Steve, do we care about the integrity of the comm field?

In the case of interpreters, its about the only thing we know about the 
application being executed. For example, a shell script will have exe=/bin/sh, 
so comm= is our only clue.

-Steve

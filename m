Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbaDBSSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:18:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876AbaDBSSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:18:40 -0400
Message-ID: <1396462716.2608.1.camel@localhost>
Subject: Re: [PATCH] integrity: get comm using lock to avoid race in string
 printing
From: Eric Paris <eparis@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Steve Grubb <sgrubb@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Wed, 02 Apr 2014 14:18:36 -0400
In-Reply-To: <1396462368.20325.26.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <11db0d126ef0ec7506ef5cb6f2f21c926d206436.1396455228.git.rgb@redhat.com>
	 <1396460387.20325.22.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <6292885.20TorKeRiK@x2>
	 <1396462368.20325.26.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 14:12 -0400, Mimi Zohar wrote:
> On Wed, 2014-04-02 at 14:00 -0400, Steve Grubb wrote: 
> > Hello Mimi,
> > 
> > On Wednesday, April 02, 2014 01:39:47 PM Mimi Zohar wrote:
> > > This change is already being upstreamed as commit 73a6b44 "Integrity:
> > > Pass commname via get_task_comm()".
> > 
> > While I was looking at Richard's patch, I noticed a few places where cause and 
> > op are logged and the string isn't tied together with a _ or -. These are in 
> > ima/ima_appraise.c line 383, and ima/ima_policy.c lines 333, 657, and 683. Are 
> > these fixed upstream? Or should a patch be made?
> 
> Nothing has changed in terms of 'cause' and 'op'.  I would suggest
> making the changes in integrity_audit.c: integrity_audit_msg().

The question is actually, do you know of anyone who is expecting the
space, instead of a more 'audit standard' - or _ ?  If not, we'll change
it.  If so, we'll discuss more   :)

-Eric


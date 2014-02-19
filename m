Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaBSNsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:48:24 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37721 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaBSNsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:48:22 -0500
MIME-Version: 1.0
In-Reply-To: <20140218232702.GA26051@redhat.com>
References: <20140218220606.GA9712@redhat.com>
	<alpine.DEB.2.02.1402181429060.20772@chino.kir.corp.google.com>
	<20140218232702.GA26051@redhat.com>
Date: Wed, 19 Feb 2014 22:48:21 +0900
Message-ID: <CAC5umyi2VSQZfUfNswSBzB3QuKq4Osm3oof88b1o1Gi-sc6xVQ@mail.gmail.com>
Subject: Re: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-19 8:27 GMT+09:00 Dave Jones <davej@redhat.com>:
> On Tue, Feb 18, 2014 at 02:32:02PM -0800, David Rientjes wrote:
>  > On Tue, 18 Feb 2014, Dave Jones wrote:
>  >
>  > > /proc/self/make-it-fail is a boolean, but accepts any number, including
>  > > negative ones. Change variable to unsigned, and cap upper bound at 1.
>  >
>  > Hmm, this would break anything that uses anything other than one to enable
>  > it, but it looks like Documentation/fault-injection/fault-injection.txt
>  > only provides an example for when it does equal one, so it's probably an
>  > ok change.  I'm just wondering why non-zero is wrong?  Is this an
>  > interface that will be extended to support other modes?
>
> "Wrong" is perhaps too strong a word, but we only ever check it for non-zero state,
> so it seems at best suboptimal to allow strange configurations.
>
> When I saw I could set it to nonsense values like -1, I figured it could
> use some idiot proofing. The lack of any checking at all surprised me.
>
> Future extension of this interface seems unlikely given the boolean sounding name.
> (Though we've done that in the past with things like the overcommit_memory sysctl,
>  with pretty awful end-user results).

I don't have any plans to extend /proc/self/make-it-fail to support
other than 0 or 1.  So I have no objection against this change.

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaGKQQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbaGKQQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:16:51 -0400
Message-ID: <1405095407.2357.1.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32
 filter
From: Eric Paris <eparis@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <aviro@redhat.com>, Will Drewry <wad@chromium.org>
Date: Fri, 11 Jul 2014 12:16:47 -0400
In-Reply-To: <1458762.ra4TnS54ZN@sifl>
References: <cover.1405023592.git.rgb@redhat.com>
	 <6a69eb94b4cfac5f94b229c2eb2ebc402aac722a.1405023592.git.rgb@redhat.com>
	 <53BF62AA.20105@zytor.com> <1458762.ra4TnS54ZN@sifl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 12:11 -0400, Paul Moore wrote:
> On Thursday, July 10, 2014 09:06:02 PM H. Peter Anvin wrote:
> > Incidentally: do seccomp users know that on an x86-64 system you can
> > recevie system calls from any of the x86 architectures, regardless of
> > how the program is invoked?  (This is unusual, so normally denying those
> > "alien" calls is the right thing to do.)
> 
> I obviously can't speak for all seccomp users, but libseccomp handles this by 
> checking the seccomp_data->arch value at the start of the filter and killing 
> (by default) any non-native architectures.  If you want, you can change this 
> default behavior or add support for other architectures (e.g. create a filter 
> that allows both x86-64 and x32 but disallows x86, or any combination of the 
> three for that matter).

Maybe libseccomp does some HORRIFIC contortions under the hood, but the
interface is crap...  Since seccomp_data->arch can't distinguish between
X32 and X86_64.  If I write a seccomp filter which says

KILL arch != x86_64
KILL init_module
ALLOW everything else

I can still call init_module, I just have to use the X32 variant.

If libseccomp is translating:

KILL arch != x86_64 into:

KILL arch != x86_64
KILL syscall_nr >= 2000

That's just showing how dumb the kernel interface is...   Good for you
guys, but the kernel is just being dumb   :)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161395AbaJ3WgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:36:08 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:58201 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035AbaJ3WgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:36:06 -0400
MIME-Version: 1.0
In-Reply-To: <20141030171247.GC378@htj.dyndns.org>
References: <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org> <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk> <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net> <20141030124333.GA29540@htj.dyndns.org>
 <CAAAKZwvJOKsrj_yczDGaNLaNYo+_=HzsTLwDdcaTJqO2VMy8uA@mail.gmail.com> <20141030171247.GC378@htj.dyndns.org>
From: Tim Hockin <thockin@hockin.org>
Date: Thu, 30 Oct 2014 15:35:44 -0700
X-Google-Sender-Auth: Bcpzy6Hfd93Lzg8QFBXuAX2SkTs
Message-ID: <CAAAKZwsGs4e1T8Xb=kEGY3O=ZJS4DgOe7Oi5UPUXz5cwiRcH9g@mail.gmail.com>
Subject: Re: Cache Allocation Technology Design
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Vikas Shivappa <vikas.shivappa@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:12 AM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Oct 30, 2014 at 07:58:34AM -0700, Tim Hockin wrote:
>> Another reason unified hierarchy is a bad model.
>
> Things wrong with this message.
>
> 1. Top posted.  It isn't clear which part you're referring to and this
>    was pointed out to you multiple times in the past.

I occasionally fall victim to gmail's defaults.  I apologize for that.

> 2. No real thoughts or technical details.  Maybe you had some in your
>    head but nothing was elaborated.  This forces me to guess what you
>    had on mind when you produced the above sentence and of course me
>    not being you this takes a considerable amount of brain cycle and
>    I'd still end up with multiple alternative scenarios that I'll have
>    to cover.

I think the conversation is well enough understood by the people for
whom this bit of snark was intended that reading my mind was not that
hard.  That said, it was overly snark-tastic, and sent in haste.

My point, of course, was that here is an example of something which
maps very well to the idea of cgroups (a set of processes that share
some controller) but DOES NOT map well to the unified hierarchy model.
It must be managed more carefully than arbitrary hierarchy can
enforce.  The result is the mish-mash of workarounds proposed in this
thread to force it into arbitrary hierarchy mode, including this
no-win situation of running out of hardware resources - it is going to
fail.  Will it fail at cgroup creation time (doesn't scale to
arbitrary hierarchy) or will it fail when you add processes to it
(awkward at best) or will it fail when you flip some control file to
enable the feature?

I know the unified hierarchy ship has sailed, so there's not
non-snarky way to argue the point any further, but this is such an
obvious case, to me, that I had to say something.

Tim

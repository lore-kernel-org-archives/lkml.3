Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3A2QwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:52:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3A2QwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:52:14 -0500
Date: Tue, 29 Jan 2013 17:51:25 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Petr Holasek <pholasek@redhat.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>, Anton Arapov <anton@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/11] ksm: NUMA trees and page migration
Message-ID: <20130129165125.GA17671@redhat.com>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
 <20130128155452.16882a6e.akpm@linux-foundation.org>
 <51071CA0.801@ravellosystems.com>
 <51073345.4070605@ravellosystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51073345.4070605@ravellosystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Tue, Jan 29, 2013 at 04:26:13AM +0200, Izik Eidus wrote:
> On 01/29/2013 02:49 AM, Izik Eidus wrote:
> > On 01/29/2013 01:54 AM, Andrew Morton wrote:
> >> On Fri, 25 Jan 2013 17:53:10 -0800 (PST)
> >> Hugh Dickins <hughd@google.com> wrote:
> >>
> >>> Here's a KSM series
> >> Sanity check: do you have a feeling for how useful KSM is?
> >> Performance/space improvements for typical (or atypical) workloads?
> >> Are people using it?  Successfully?
> 
> 
> BTW, After thinking a bit about the word people, I wanted to see if 
> normal users of linux
> that just download and install Linux (without using special 
> virtualization product) are able to use it.
> So I google little bit for it, and found some nice results from users:
> http://serverascode.com/2012/11/11/ksm-kvm.html
> 
> But I do agree that it provide justifying value only for virtualization 
> users...

Mostly for virtualization users indeed, but I'm aware of a few non
virtualization users too:

1) CERN has been one of the early adopters of KSM and initially they
were using KSM standalone (probably because not all hypervisors they
had to deal with were KVM/linux based, while all guests were linux and
in turn KSM capable). More info in the KSM paper page 2:

http://www.kernel.org/doc/ols/2009/ols2009-pages-19-28.pdf

However lately they're running KSM in combination with KVM too, and I'm
not sure if they're still using it standalone. See the "KSM shared"
blue area in slide 12 and the comparison with KSM on and off in slide
14.

https://indico.fnal.gov/getFile.py/access?contribId=18&sessionId=4&resId=0&materialId=slides&confId=4986

2) all recent cyanogenmod in the performance menu in settings supports
KSM out of the box. You can run it for a while and then shut it
off.

Not sure how good idea it is to leave it always on, but the only
efficient cellphone/tablet powersaving design (i.e. the wakelocks +
suspend to ram) still won't waste energy while the screen is off and
the phone has suspended to ram, regardless of KSM on or off.

KSM NUMA awareness however is not needed on the cellphone :).

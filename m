Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3HUUtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab3HUUtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:49:12 -0400
Date: Wed, 21 Aug 2013 16:49:01 -0400
From: Dave Jones <davej@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: unused swap offset / bad page map.
Message-ID: <20130821204901.GA19802@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hillf Danton <dhillf@gmail.com>, Linux-MM <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130807055157.GA32278@redhat.com>
 <CAJd=RBCJv7=Qj6dPW2Ha=nq6JctnK3r7wYCAZTm=REVOZUNowg@mail.gmail.com>
 <20130807153030.GA25515@redhat.com>
 <CAJd=RBCyZU8PR7mbFUdKsWq3OH+5HccEWKMEH5u7GNHNy3esWg@mail.gmail.com>
 <20130819231836.GD14369@redhat.com>
 <CAJd=RBA-UZmSTxNX63Vni+UPZBHwP4tvzE_qp1ZaHBqcNG7Fcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBA-UZmSTxNX63Vni+UPZBHwP4tvzE_qp1ZaHBqcNG7Fcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 12:39:05PM +0800, Hillf Danton wrote:
 > On Tue, Aug 20, 2013 at 7:18 AM, Dave Jones <davej@redhat.com> wrote:
 > 
 > --- a/mm/memory.c Wed Aug  7 16:29:34 2013
 > +++ b/mm/memory.c Tue Aug 20 11:13:06 2013
 > @@ -933,8 +933,10 @@ again:
 >   if (progress >= 32) {
 >   progress = 0;
 >   if (need_resched() ||
 > -    spin_needbreak(src_ptl) || spin_needbreak(dst_ptl))
 > +    spin_needbreak(src_ptl) || spin_needbreak(dst_ptl)) {
 > +     BUG_ON(entry.val);
 >   break;
 > + }
 >   }
 >   if (pte_none(*src_pte)) {
 >   progress++;

didn't hit the bug_on, but got a bunch of 

[  424.077993] swap_free: Unused swap offset entry 000187d5
[  439.377194] swap_free: Unused swap offset entry 000187e7
[  441.998411] swap_free: Unused swap offset entry 000187ee
[  446.956551] swap_free: Unused swap offset entry 0000245f

	Dave


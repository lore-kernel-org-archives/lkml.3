Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaFDTMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaFDTMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:12:43 -0400
Date: Wed, 4 Jun 2014 15:12:28 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Brandon Philips <brandon.philips@coreos.com>
Subject: Re: Bad rss-counter is back on 3.14-stable
Message-ID: <20140604191228.GB12375@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Brandon Philips <brandon.philips@coreos.com>
References: <20140604182739.GA30340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604182739.GA30340@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 11:27:39AM -0700, Greg KH wrote:
 > Hi all,
 > 
 > Dave, I saw you mention that you were seeing the "Bad rss-counter" line
 > on 3.15-rc1, but I couldn't find any follow-up on this to see if anyone
 > figured it out, or did it just "magically" go away?
 > 
 > I ask as Brandon is seeing this same message a lot on a 3.14.4 kernel,
 > causing system crashes and problems:
 > 
 > [16591492.449718] BUG: Bad rss-counter state mm:ffff8801ced99880 idx:0 val:-1836508
 > [16591492.449737] BUG: Bad rss-counter state mm:ffff8801ced99880 idx:1 val:1836508
 > 
 > [20783350.461716] BUG: Bad rss-counter state mm:ffff8801d2b1dc00 idx:0 val:-52518
 > [20783350.461734] BUG: Bad rss-counter state mm:ffff8801d2b1dc00 idx:1 val:52518
 > 
 > [21393387.112302] BUG: Bad rss-counter state mm:ffff8801d0104e00 idx:0 val:-1767569
 > [21393387.112321] BUG: Bad rss-counter state mm:ffff8801d0104e00 idx:1 val:1767569
 > 
 > [21430098.512837] BUG: Bad rss-counter state mm:ffff880100036680 idx:0 val:-2946
 > [21430098.512854] BUG: Bad rss-counter state mm:ffff880100036680 idx:1 val:2946
 > 
 > Anyone have any ideas of a 3.15-rc patch I should be including in
 > 3.14-stable to resolve this?

hard to tell if they were the same issues I was seeing without the full
backtrace. The only bad rss bugs that I recall being fixed for sure were
the ones that Hugh nailed down right before 3.14 (887843961c4b)

I've not seen anything in a while, but that may just be because I end up
hitting other bugs before they get a chance to show.

Brandon, what kind of workload is that machine doing ? I wonder if I can
add something to trinity to make it provoke it.

	Dave

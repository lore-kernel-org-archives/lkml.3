Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3KGKnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:43:55 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:46334 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3KGKnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:43:52 -0500
Date: Thu, 7 Nov 2013 05:43:48 -0500 (EST)
From: Jerome Marchand <jmarchan@redhat.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1605509214.19935074.1383821028439.JavaMail.root@redhat.com>
In-Reply-To: <527AD5A2.70902@intel.com>
References: <1382101019-23563-1-git-send-email-jmarchan@redhat.com> <1382101019-23563-2-git-send-email-jmarchan@redhat.com> <20131105155319.732dcbefb162c2ee4716ef9d@linux-foundation.org> <1450211196.19341043.1383727340985.JavaMail.root@redhat.com> <20131106143313.1a368250df917fba0faf56fe@linux-foundation.org> <527AD5A2.70902@intel.com>
Subject: Re: [PATCH v4 2/2] mm: allow to set overcommit ratio more precisely
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF22 (Linux)/8.0.3_GA_5664)
Thread-Topic: allow to set overcommit ratio more precisely
Thread-Index: X9lNhzCk/L5kqME+glrKuBjQvQRj/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Dave Hansen" <dave.hansen@intel.com>
> To: "Andrew Morton" <akpm@linux-foundation.org>, "Jerome Marchand" <jmarchan@redhat.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
> Sent: Thursday, November 7, 2013 12:49:54 AM
> Subject: Re: [PATCH v4 2/2] mm: allow to set overcommit ratio more precisely
> 
> On 11/06/2013 02:33 PM, Andrew Morton wrote:
> > On Wed, 6 Nov 2013 03:42:20 -0500 (EST) Jerome Marchand
> > <jmarchan@redhat.com> wrote:
> >> That was my first version of this patch (actually "kbytes" to avoid
> >> overflow).
> >> Dave raised the issue that it silently breaks the user interface:
> >> overcommit_ratio is zero while the system behaves differently.
> > 
> > I don't understand that at all.  We keep overcommit_ratio as-is, with
> > the same default values and add a different way of altering it.  That
> > should be back-compatible?
> 
> Reading the old thread, I think my main point was that we shouldn't
> output overcommit_ratio=0 when overcommit_bytes>0. We need to round up
> for numbers less than 1 so that folks don't think overcommit_ratio is _off_.

This is not how current *bytes work. Also the *ratio and *bytes value
would diverge if the amount of memory changes (e.g. memory hotplug).

> 
> I was really just trying to talk you in to cramming the extra precision
> in to the _existing_ sysctl. :)  I don't think bytes vs. ratio is really
> that big of a deal.
> 

If everybody agrees on overcommit_kbytes, I can resend my original patch.

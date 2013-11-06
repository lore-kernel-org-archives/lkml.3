Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab3KFIm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:42:56 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38783 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab3KFImz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:42:55 -0500
Date: Wed, 6 Nov 2013 03:42:20 -0500 (EST)
From: Jerome Marchand <jmarchan@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        dave hansen <dave.hansen@intel.com>
Message-ID: <1450211196.19341043.1383727340985.JavaMail.root@redhat.com>
In-Reply-To: <20131105155319.732dcbefb162c2ee4716ef9d@linux-foundation.org>
References: <1382101019-23563-1-git-send-email-jmarchan@redhat.com> <1382101019-23563-2-git-send-email-jmarchan@redhat.com> <20131105155319.732dcbefb162c2ee4716ef9d@linux-foundation.org>
Subject: Re: [PATCH v4 2/2] mm: allow to set overcommit ratio more precisely
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF22 (Linux)/8.0.3_GA_5664)
Thread-Topic: allow to set overcommit ratio more precisely
Thread-Index: vmEQXa6c4meyr6nxaL+2qkPfDwXbJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Andrew Morton" <akpm@linux-foundation.org>
> To: "Jerome Marchand" <jmarchan@redhat.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, "dave hansen" <dave.hansen@intel.com>
> Sent: Wednesday, November 6, 2013 12:53:19 AM
> Subject: Re: [PATCH v4 2/2] mm: allow to set overcommit ratio more precisely
> 
> On Fri, 18 Oct 2013 14:56:59 +0200 Jerome Marchand <jmarchan@redhat.com>
> wrote:
> 
> > Some applications that run on HPC clusters are designed around the
> > availability of RAM and the overcommit ratio is fine tuned to get the
> > maximum usage of memory without swapping. With growing memory, the 1%
> > of all RAM grain provided by overcommit_ratio has become too coarse
> > for these workload (on a 2TB machine it represents no less than
> > 20GB).
> > 
> > This patch adds the new overcommit_ratio_ppm sysctl variable that
> > allow to set overcommit ratio with a part per million precision.
> > The old overcommit_ratio variable can still be used to set and read
> > the ratio with a 1% precision. That way, overcommit_ratio interface
> > isn't broken in any way that I can imagine.
> 
> The way we've permanently squished this mistake in the past is to
> switch to "bytes".  See /proc/sys/vm/*bytes.
> 
> Would that approach work in this case?
> 

That was my first version of this patch (actually "kbytes" to avoid
overflow).
Dave raised the issue that it silently breaks the user interface:
overcommit_ratio is zero while the system behaves differently.

Jerome

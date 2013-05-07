Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3EGLej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab3EGLei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:34:38 -0400
Date: Tue, 7 May 2013 13:34:29 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@us.ibm.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Juan Quintela <quintela@redhat.com>, Hugh Dickins <hughd@google.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 1/4] mm: madvise MADV_USERFAULT
Message-ID: <20130507113429.GB12538@redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
 <1367870221-12676-2-git-send-email-aarcange@redhat.com>
 <20130507111629.GA10720@hawk.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507111629.GA10720@hawk.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, May 07, 2013 at 01:16:30PM +0200, Andrew Jones wrote:
> On Mon, May 06, 2013 at 09:56:58PM +0200, Andrea Arcangeli wrote:
> > @@ -405,6 +420,7 @@ madvise_behavior_valid(int behavior)
> >  	case MADV_HUGEPAGE:
> >  	case MADV_NOHUGEPAGE:
> >  #endif
> > +	case MADV_USERFAULT:
> 
> Missing MADV_NOUSERFAULT: here

Right, thanks! Folded the below in patch 1/4.

diff --git a/mm/madvise.c b/mm/madvise.c
index 2ecab73..8828e5c 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -421,6 +421,7 @@ madvise_behavior_valid(int behavior)
 	case MADV_NOHUGEPAGE:
 #endif
 	case MADV_USERFAULT:
+	case MADV_NOUSERFAULT:
 	case MADV_DONTDUMP:
 	case MADV_DODUMP:
 		return 1;

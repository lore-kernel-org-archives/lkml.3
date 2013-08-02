Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab3HBPLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:11:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49754 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3HBPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:11:44 -0400
Date: Fri, 2 Aug 2013 08:11:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rich Felker <dalias@aerifal.cx>
Cc: Christoph Hellwig <hch@infradead.org>, Colin Cross <ccross@google.com>,
        lkml <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>, libc-alpha@sourceware.org
Subject: Re: RFC: named anonymous vmas
Message-ID: <20130802151141.GA4439@infradead.org>
References: <CAMbhsRQU=xrcum+ZUbG3S+JfFUJK_qm_VB96Vz=PpL=vQYhUvg@mail.gmail.com>
 <20130622103158.GA16304@infradead.org>
 <CAMbhsRTz246dWPQOburNor2HvrgbN-AWb2jT_AEywtJHFbKWsA@mail.gmail.com>
 <20130801082951.GA23563@infradead.org>
 <20130801083608.GJ221@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801083608.GJ221@brightrain.aerifal.cx>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 04:36:08AM -0400, Rich Felker wrote:
> I'm not sure what the purpose is. shm_open with a long random filename
> and O_EXCL|O_CREAT, followed immediately by shm_unlink, is just as
> good except in the case where you have a malicious user killing the
> process in between these two operations.

The Android people already have an shm API doesn't leave traces in the
filesystem, and I at least conceptually agree that having an API that
doesn't introduce posisble other access is a good idea.  This is the
same reason why the O_TMPFILE API was added in this releases.


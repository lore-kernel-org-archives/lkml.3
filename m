Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3FXLsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:48:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3FXLse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:48:34 -0400
Date: Mon, 24 Jun 2013 04:48:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFC: named anonymous vmas
Message-ID: <20130624114832.GA9961@infradead.org>
References: <CAMbhsRQU=xrcum+ZUbG3S+JfFUJK_qm_VB96Vz=PpL=vQYhUvg@mail.gmail.com>
 <20130622103158.GA16304@infradead.org>
 <CAMbhsRTz246dWPQOburNor2HvrgbN-AWb2jT_AEywtJHFbKWsA@mail.gmail.com>
 <kq4v0b$p8p$3@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kq4v0b$p8p$3@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 12:47:29PM -0700, Alex Elsayed wrote:
> Couldn't this be done by having a root-only tmpfs, and having a userspace 
> component that creates per-app directories with restrictive permissions on 
> startup/app install? Then each app creates files in its own directory, and 
> can pass the fds around.

Honestly having a device that allows passing fds around that can be
mmaped sounds a lot simpler.  I have to admit that I expect /dev/zero
to do this, but looking at the code it creates new file structures
at ->mmap time which would defeat this.


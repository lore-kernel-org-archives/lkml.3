Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3FXR07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:26:59 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:48651 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3FXR06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:26:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130624114832.GA9961@infradead.org>
References: <CAMbhsRQU=xrcum+ZUbG3S+JfFUJK_qm_VB96Vz=PpL=vQYhUvg@mail.gmail.com>
	<20130622103158.GA16304@infradead.org>
	<CAMbhsRTz246dWPQOburNor2HvrgbN-AWb2jT_AEywtJHFbKWsA@mail.gmail.com>
	<kq4v0b$p8p$3@ger.gmane.org>
	<20130624114832.GA9961@infradead.org>
Date: Mon, 24 Jun 2013 10:26:57 -0700
Message-ID: <CAMbhsRTdMaVR1LZRigumDqz_e5FgeyfJLrSHCDs8t7ywrmumTQ@mail.gmail.com>
Subject: Re: RFC: named anonymous vmas
From: Colin Cross <ccross@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elsayed <eternaleye@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 4:48 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Jun 22, 2013 at 12:47:29PM -0700, Alex Elsayed wrote:
>> Couldn't this be done by having a root-only tmpfs, and having a userspace
>> component that creates per-app directories with restrictive permissions on
>> startup/app install? Then each app creates files in its own directory, and
>> can pass the fds around.

If each app gets its own writable directory that's not really
different than a world writable tmpfs.  It requires something that
watches for apps to exit for any reason and cleans up their
directories, and it requires each app to come up with an unused name
when it wants to create a file, and the kernel can give you both very
cleanly.

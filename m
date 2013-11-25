Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3KYXfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:35:40 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:50508 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3KYXfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:35:39 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 25 Nov 2013 15:35:18 -0800
Message-ID: <CALCETrVsZfHqKT-+SHBq7kYx-_3Gvr=mUYUw81uvNuiMxgLWNA@mail.gmail.com>
Subject: Setting stack NUMA policy?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to arrange for a process to have a different memory policy
on its stack as compared to everything else (e.g. mapped libraries).
Before I start looking for kludges, is there any clean way to do this?

So far, the best I can come up with is to either parse /proc/self/maps
on startup or to deduce the stack range from the stack pointer and
then call mbind.  Then, for added fun, I'll need to hook mmap so that
I can mbind MAP_STACK vmas that are created for threads.

This is awful.  Is there something better?

(What I really want is a separate policy for MAP_SHARED vs MAP_PRIVATE.)

--Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbaDVWMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:12:37 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:43052 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbaDVWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:12:32 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Apr 2014 15:12:11 -0700
Message-ID: <CALCETrXE_T-3eKmVKZNkAfoyvC0CcUATDK7fGPvQrR9H=RHQag@mail.gmail.com>
Subject: How do I make a clean mount namespace?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to set up a little container.  So I unshare the mount namespace
and mount something somewhere (say /mnt) that I want to be my new
root.  Now what?

pivot_root("/mnt", "/mnt/garbage") seems to frequently return -EBUSY.

mounting /mnt onto / using MS_MOVE seems to succeed, but / still
points at the old root.

Am I missing a clean way to do this?  I want a way to say "make this
mountpoint be the root of the whole mount namespace and lazy-unmount
everything outside it".  If there is no straightforward way to do
that, can we add one?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC

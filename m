Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaBQWqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:46:52 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39325 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaBQWqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:46:49 -0500
Date: Mon, 17 Feb 2014 14:46:45 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bcache@vger.kernel.org
Subject: Re: New bcache compiler warning (was: Re: bcache: Minor fixes from
 kbuild robot)
Message-ID: <20140217224645.GC11655@kmo>
References: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com>
 <530279EC.5010605@infradead.org>
 <CAMuHMdUnCdEoyD+seYXJD+e4bED9=ceUCC7NYsoRa1_vc3g4Hw@mail.gmail.com>
 <20140217214553.GB11655@kmo>
 <530290DF.1060008@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530290DF.1060008@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:44:47PM -0800, Randy Dunlap wrote:
> Could that cause a truncation?  unsigned means unsigned int.
> Can unsigned int be smaller (fewer bits) than the k pointer?
> If so, is that OK or a problem?

It's just truncating the offset of the pointer within the struct bset, which is
part of a btree node - the thing that's being cast is restricted to be no bigger
than a btree node, which is at most a few mb.

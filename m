Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab3BKXAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:00:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42548 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab3BKXAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:00:08 -0500
Date: Tue, 12 Feb 2013 00:00:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 1/2] add helper for highmem checks
Message-ID: <20130211230003.GG2683@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mingo@kernel.org, tglx@linutronix.de
References: <20130208202813.62965F25@kernel.stglabs.ibm.com>
 <20130209094121.GB17728@pd.tnic>
 <20130209104751.GC17728@pd.tnic>
 <51192B39.9060501@linux.vnet.ibm.com>
 <20130211182826.GE2683@pd.tnic>
 <7794bbcd-5d5a-4e81-87fd-68b0aa17a556@email.android.com>
 <20130211223405.GF2683@pd.tnic>
 <511974D3.8020900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <511974D3.8020900@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 02:46:43PM -0800, H. Peter Anvin wrote:
> The X server itself used to do that. Are you saying that wdm is a
> *privileged process*?

Nah, it is a simple display manager you start with /etc/init.d/wdm init
script. Like the other display managers gdm, kdm, etc.

But it looks like wdm has copied stuff from xdm (from the README):

"Wdm is a modification of XFree86's xdm package for graphically handling
authentication and system login. Most of xdm has been preserved (XFree86
4.2.1.1) with the Login interface based on a WINGs implementation using
Tom Rothamel's "external greet" interface (see AUTHORS)."

And from looking at the part in the source which does the /dev/mem
accesses, it comes from XFree86's source apparently, this is at the
beginning of src/wdm/genauth.c:

/* $Xorg: genauth.c,v 1.5 2001/02/09 02:05:40 xorgcvs Exp $ */
/*

   Copyright 1988, 1998  The Open Group
...

so this explains why it behaves like the X server in that respect.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

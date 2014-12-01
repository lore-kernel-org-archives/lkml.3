Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbaLASgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:36:08 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:51791 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaLASgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:36:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141201182519.GA16749@node.dhcp.inet.fi>
References: <20141119021902.GA14216@redhat.com>
	<CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
	<20141119145902.GA13387@redhat.com>
	<546D0530.8040800@mit.edu>
	<20141120152509.GA5412@redhat.com>
	<20141125122217.GA15280@arm.com>
	<20141201114854.GB18466@arm.com>
	<CA+55aFyhB5LBVadA5TfuX8+TrZZWTHwT-2NCYRLat8Fp6eBjgw@mail.gmail.com>
	<20141201171036.GH18466@arm.com>
	<CA+55aFwooh31=GMVUoriev+t92=roye_ck+czqr48M1sQ3UOMg@mail.gmail.com>
	<20141201182519.GA16749@node.dhcp.inet.fi>
Date: Mon, 1 Dec 2014 10:36:04 -0800
X-Google-Sender-Auth: xz0wnQyE6lxT1HNIwwOdGk-uFxQ
Message-ID: <CA+55aFz+ODi34J2n0kzXm+v++B7KW1e9NSFU=f-jgonPA1bNxg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Will Deacon <will.deacon@arm.com>, Tejun Heo <tj@kernel.org>,
        Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 10:25 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>
> No idea about oom_score, but kernel happily accepts chmod on any file
> under /proc/PID/net/.

/proc used to accept that fairly widely, but no, we tightened things
down, and core /proc files end up not accepting chmod. See
'proc_setattr()':

        if (attr->ia_valid & ATTR_MODE)
                return -EPERM;

although particular /proc files could choose to not use 'proc_setattr'
if they want to.

The '/proc/pid/net' subtree is obviously not doing that. No idea why,
and probably for no good reason.

                     Linus

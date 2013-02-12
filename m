Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3BLHNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 02:13:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46784 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3BLHNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 02:13:33 -0500
Message-ID: <5119EB71.6080508@zytor.com>
Date: Mon, 11 Feb 2013 23:12:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user()
 warnings
References: <20130209110031.GA17833@n2100.arm.linux.org.uk> <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org> <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com> <5119C34B.70207@zytor.com> <CA+55aFx7KA-inJJog0v_cAsU0S2FeAN61pyvoUO8pbaxEAWFag@mail.gmail.com> <CA+55aFzmWfOQzVMPJUah3oEsn-aaeN5qtO=7P3MQUfLZmEFJZA@mail.gmail.com>
In-Reply-To: <CA+55aFzmWfOQzVMPJUah3oEsn-aaeN5qtO=7P3MQUfLZmEFJZA@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to be sure, I re-ran the comparison using gcc 4.6.3 instead of gcc
4.7.2.  With gcc 4.6.3 I consistently get a few hundred bytes longer
with the bitfield variant than with the pre-get_user() baseline.

I looked at some of the diffed disassembly, and the differences seem to
be in the code generated downstream of __get_user_1 and __get_user_2,
which I guess is to be expected, mostly in the form of padding.

Annoyingly enough in *both* cases I found unnecessary instructions like:

+c12f6fbb:      0f b7 d2                movzwl %dx,%edx

	-hpa


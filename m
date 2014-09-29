Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaI2Nkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbaI2Nkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:40:32 -0400
Date: Mon, 29 Sep 2014 09:40:08 -0400
From: Dave Jones <davej@redhat.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Quark: Enable correct cache size/type reporting
Message-ID: <20140929134008.GA7764@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bryan O'Donoghue <pure.logic@nexus-software.ie>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1411956372-16469-1-git-send-email-pure.logic@nexus-software.ie>
 <1411956372-16469-2-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411956372-16469-2-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 03:06:12AM +0100, Bryan O'Donoghue wrote:
 > Quark X1000 lacks cpuid(4). It has cpuid(2) but returns no cache
 > descriptors we can work with i.e. cpuid(2) returns
 > eax=0x00000001 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
 > 
 > Quark X1000 contains a 16k 4-way set associative unified L1 cache
 > with 256 sets
 > 
 > This patch emulates cpuid(4) in a similar way to other x86
 > processors like AMDs which don't support cpuid(4). The Quark code
 > is based on the existing AMD code.
 
This looks like it would work, but I wonder if it would be a lot
simpler to do something like what we do in centaur_size_cache()
which is the other case I recall where we had to override
the CPUs definition of cache size.

	Dave


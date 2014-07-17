Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbaGQPTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:19:07 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:57751
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932908AbaGQPTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:19:05 -0400
Date: Thu, 17 Jul 2014 10:19:03 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] doc: Add remote CPU access details and others to
 this_cpu_ops.txt
In-Reply-To: <53C7E234.3020503@gmail.com>
Message-ID: <alpine.DEB.2.11.1407171005450.28248@gentwo.org>
References: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407170848490.27584@gentwo.org> <53C7D93B.4090006@gmail.com> <alpine.DEB.2.11.1407170934220.28121@gentwo.org> <53C7E234.3020503@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding atomic_t in per cpu areas: I am uncomfortable especially
because both locked and unlocked RMW write operations could be acting on
values in the same cacheline. I am concerned that the unlocked operation
could have an unpredictable result.


f.e. the following per cpu data structure

struct test {
	atomic_t a;
	int b;
} onecacheline;


Local cpu does

	this_cpu_inc(onecacheline.b);

If this is racing with a remote cpus:

	atomic_inc(percpu(&a, cpu))

then we have on x86 a increment operation with locked semantics racing
with an unlocked one on the same cacheline.


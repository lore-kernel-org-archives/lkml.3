Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab3FNPlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:41:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:55047 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3FNPlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:41:05 -0400
Message-ID: <51BB398D.6040403@linutronix.de>
Date: Fri, 14 Jun 2013 17:41:01 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Clark Williams <clark@redhat.com>,
        stable-rt@vger.kernel.org
Subject: Re: [PATCH RT 2/4] acpi/rt: Convert acpi_gbl_hardware lock back to
 a raw_spinlock_t
References: <20130219053116.706325380@goodmis.org>  <20130219053159.965355809@goodmis.org> <1371223012.9844.317.camel@gandalf.local.home>
In-Reply-To: <1371223012.9844.317.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 05:16 PM, Steven Rostedt wrote:
> Hi Sebastian,

Hi Steven,

> 
> Any reason that this patch was dropped for 3.8? We hit this exact same
> bug recently with a 3.8-rt kernel.

No particular reason. Going through my log of the queue I have to say
that it was never in the queue starting v3.8.

The only ACPI patches that were dropped are:

 # ACPI
 # Dropped those two as they cause a scheduling in atomic failure and
 # we have no clue why we made those locks raw in the first place.
 # acpi-make-gbl-hardware-lock-raw.patch
 # acpi-make-ec-lock-raw-as-well.patch

 # This one is just a follow up to the raw spin locks
 # Simple raw spinlock based waitqueue
 # wait-simple-version.patch
 # acpi-gpe-use-wait-simple.patch

but that wasn't me.

In that case I try to bring it back in.

> -- Steve

Sebastian

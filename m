Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaICTPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:15:05 -0400
Received: from xes-mad.com ([216.165.139.218]:22030 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaICTPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:15:03 -0400
From: Peter Tyser <ptyser@xes-inc.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] x86, lpc, Allow only one load of lpc_ich
Date: Wed, 03 Sep 2014 14:13:55 -0500
Message-ID: <2934553.BlOlR0jvHm@petert>
User-Agent: KMail/4.13.3 (Linux/3.13.0-34-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <54075663.8090204@redhat.com>
References: <1409695097-5831-1-git-send-email-prarit@redhat.com> <1598720.9R5g9ohVoY@petert> <54075663.8090204@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can you give more background on your hardware and firmware setup?
> 
> Unfortunately I cannot :(  The system isn't "mine" per se.  It is (as the
> dumps show) IBM's.

Can you look at the IBM manual and see info about which chipsets are used, and 
how they are connected?

> Are there
> 
> > physically two ICH bridges, or just one that is showing up two times due
> > to a firmware bug?
> 
> I can answer that.  There are two physical ICH bridges, and according to
> Intel one should be masked off.  We shouldn't run with two.

Interesting.  The "normal" setup I'm familiar with is multiple CPUs wired up 
to one IOH, and that IOH would be wired up to the ICH10.  There'd only be one 
ICH10 in this configuration though.  An example is on page 30 of 
http://www.intel.com/content/dam/www/public/us/en/documents/datasheets/5520-5500-chipset-ioh-datasheet.pdf  I'm not sure how it'd be possible to wire up 2 
ICH10s to one CPU?

How are you determining the number of ICH10s?  You could try running "lspci -
v" and comparing the PCI BARs on the duplicate devices.  If the duplicate PCI 
devices have the same BAR values, it would indicate that there is only one 
ICH10.  Could you send the output of "lspci -v"?

Regards,
Peter

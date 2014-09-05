Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaIEUmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:42:06 -0400
Received: from mail.orcon.net.nz ([219.88.242.59]:54622 "EHLO
	mail.orcon.net.nz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752457AbaIEUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:42:01 -0400
Date: Sat, 6 Sep 2014 08:39:51 +1200
From: Michael Cree <mcree@orcon.net.nz>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Marc Gauthier <marc@cadence.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>
Subject: Re: bit fields && data tearing
Message-ID: <20140905203951.GA4053@omega>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
	Peter Hurley <peter@hurleysoftware.com>,
	Marc Gauthier <marc@cadence.com>,
	"paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Laight <David.Laight@ACULAB.COM>,
	Jakub Jelinek <jakub@redhat.com>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	"linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Miroslav Franc <mfranc@redhat.com>,
	Richard Henderson <rth@twiddle.net>,
	"linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>
References: <1409824374.4246.62.camel@pasglop>
 <5408E458.3@zytor.com>
 <54090AF4.7060406@hurleysoftware.com>
 <54091B30.2090509@zytor.com>
 <20140905081648.GB5281@omega>
 <20140905180950.GU5001@linux.vnet.ibm.com>
 <540A05F7.1070202@hurleysoftware.com>
 <20140905190506.GV5001@linux.vnet.ibm.com>
 <8CA974F497CA064FA9926E10ABCC061F05F97E7B77@MAILSJ4.global.cadence.com>
 <540A19B8.4010907@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540A19B8.4010907@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Bayes-Prob: 0.0001 (Score 0: No Bayes scoring rules defined, tokens from: outbound)
X-Spam-Score: -2.63 () [Hold at 3.00] FREEMAIL_FROM:0.001,FSL_HELO_NON_FQDN_1:0.001,HELO_NO_DOMAIN:0.001,RDNS_DYNAMIC:0.363,CC(NZ:-3)
X-CanIt-Geo: ip=60.234.221.162; country=NZ; latitude=-41.0000; longitude=174.0000; http://maps.google.com/maps?q=-41.0000,174.0000&z=6
X-CanItPRO-Stream: base:outbound
X-Canit-Stats-ID: 01MLwDWh5 - f42b6d384d23 - 20140906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:14:48PM -0400, Peter Hurley wrote:
> Second, in the body of the document:
> 
> "The Linux kernel no longer supports pre-EV56 Alpha CPUs, because these
> older CPUs _do not provide_ atomic one-byte and two-byte loads and stores."

Let's be clear here, the pre-EV56 Alpha CPUs do provide an atomic
one-byte and two-byte load and store; it's just that one must use
locked load and store sequences to achieve atomicity.  The point,
I think, is that the pre-EV56 Alpha CPUs provide non-atomic one-byte
and two-byte load and stores as the norm, and that is the problem.

Cheers
Michael.

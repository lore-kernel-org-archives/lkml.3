Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaIHTQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:16:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59168 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbaIHTQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:16:03 -0400
Message-ID: <540DFFB2.4000509@zytor.com>
Date: Mon, 08 Sep 2014 12:12:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: paulmck@linux.vnet.ibm.com, Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jakub Jelinek <jakub@redhat.com>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Oleg Nesterov <oleg@redhat.com>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Subject: Re: bit fields && data tearing
References: <5408C0AB.6050801@hurleysoftware.com>		 <20140905001751.GL5001@linux.vnet.ibm.com>		 <1409883098.5078.14.camel@jarvis.lan>	 <5409243C.4080704@hurleysoftware.com>		 <20140905040645.GO5001@linux.vnet.ibm.com>		 <1410066442.12512.13.camel@jarvis.lan>		 <20140907162146.GK5001@linux.vnet.ibm.com>		 <1410116687.2027.19.camel@jarvis.lan>		 <20140907230019.GO5001@linux.vnet.ibm.com>		 <6092b453-e0c9-4f6d-922b-48bce988f774@email.android.com>		 <20140907233655.GR5001@linux.vnet.ibm.com>		 <154b540a-df47-4f3e-bdda-ab5d2e72723a@email.android.com>	 <1410155802.2027.36.camel@jarvis.lan> <540DF17C.9080509@zytor.com> <1410203369.2027.56.camel@jarvis.lan>
In-Reply-To: <1410203369.2027.56.camel@jarvis.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 12:09 PM, James Bottomley wrote:
> 
> Um, I think you need to re-read the thread; that's not what I said at
> all. It's even written lower down: "PA can't do atomic bit sets (no
> atomic RMW except the ldcw operation) it can do atomic writes to
> fundamental sizes (byte, short, int, long) provided gcc emits the
> correct primitive".  The original question was whether atomicity
> required native bus width access, which we currently assume, so there's
> no extant problem.
> 

The issue at hand was whether or not partially overlapped (but natually
aligned) writes can pass each other.  *This* is the aggressive
relaxation to which I am referring.

I would guess that that is a very unusual constraint.

	-hpa


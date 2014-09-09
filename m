Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaIIDVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 23:21:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34958 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbaIIDVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 23:21:20 -0400
Message-ID: <540E7211.9020909@zytor.com>
Date: Mon, 08 Sep 2014 20:20:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Peter Hurley <peter@hurleysoftware.com>
CC: paulmck@linux.vnet.ibm.com,
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
References: <21512.10628.412205.873477@gargle.gargle.HOWL>			 <20140904090952.GW17454@tucnak.redhat.com>			 <540859EC.5000407@hurleysoftware.com>			 <20140904175044.4697aee4@alan.etchedpixels.co.uk>			 <5408C0AB.6050801@hurleysoftware.com>			 <20140905001751.GL5001@linux.vnet.ibm.com>			 <1409883098.5078.14.camel@jarvis.lan>		 <5409243C.4080704@hurleysoftware.com>			 <20140905040645.GO5001@linux.vnet.ibm.com>			 <1410066442.12512.13.camel@jarvis.lan>			 <20140907162146.GK5001@linux.vnet.ibm.com>		 <1410116687.2027.19.camel@jarvis.lan>	 <540CC305.8010407@hurleysoftware.com> <1410155407.2027.29.camel@jarvis.lan>	 <540E3BFF.7080307@hurleysoftware.com> <1410231392.2028.15.camel@jarvis.lan>
In-Reply-To: <1410231392.2028.15.camel@jarvis.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 07:56 PM, James Bottomley wrote:
>>
>> Yeah, the extra requirement I added is basically nonsense, since the
>> only issue is what instructions the compiler is emitting. So if compiler
>> thinks the alignment is natural and combines the writes -- ok. If the
>> compiler thinks the alignment is off and doesn't combine the writes --
>> also ok.
> 
> Yes, I think I can agree that the only real problem is gcc thinking the
> store or load needs splitting.
> 

That seems much saner, and yes, that applies to any architecture which
needs unaligned references.  Now, if the references are *actually*
unaligned they can end up being split even on x86, especially if they
cross cache line boundaries.

	-hpa



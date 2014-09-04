Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaIDTmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:42:53 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47254 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754983AbaIDTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:42:50 -0400
Message-ID: <5408C0AB.6050801@hurleysoftware.com>
Date: Thu, 04 Sep 2014 15:42:35 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Jakub Jelinek <jakub@redhat.com>, Mikael Pettersson <mikpelinux@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>, Oleg Nesterov <oleg@redhat.com>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com>	<54079B70.4050200@hurleysoftware.com>	<1409785893.30640.118.camel@pasglop>	<21512.10628.412205.873477@gargle.gargle.HOWL>	<20140904090952.GW17454@tucnak.redhat.com>	<540859EC.5000407@hurleysoftware.com> <20140904175044.4697aee4@alan.etchedpixels.co.uk>
In-Reply-To: <20140904175044.4697aee4@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 12:50 PM, One Thousand Gnomes wrote:
>> Besides updating the documentation, it may make sense to do something
>> arch-specific. Just bumping out storage on arches that don't need it
>> seems wasteful, as does generating bus locks on arches that don't need it.
>> Unfortunately, the code churn looks unavoidable.
> 
> The arch specific is pretty much set_bit and friends. Bus locks on a
> locally owned cache line should not be very expensive on anything vaguely
> modern, while uniprocessor boxes usually only have to generate set_bit
> as a single instruction so it is interrupt safe.

Or we could give up on the Alpha.

It's not just the non-atomic bytes; we could do away with the
read_barrier_depends() which hardly any code gets correctly anyway.

Regards,
Peter Hurley


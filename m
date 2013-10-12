Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3JLWaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:30:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39474 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab3JLWai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 18:30:38 -0400
Message-ID: <5259CD44.2000200@zytor.com>
Date: Sat, 12 Oct 2013 15:29:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
CC: sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 09:51 AM, Neil Horman wrote:
> Sébastien Dugué reported to me that devices implementing ipoib (which don't have
> checksum offload hardware were spending a significant amount of time computing
> checksums.  We found that by splitting the checksum computation into two
> separate streams, each skipping successive elements of the buffer being summed,
> we could parallelize the checksum operation accros multiple alus.  Since neither
> chain is dependent on the result of the other, we get a speedup in execution (on
> hardware that has multiple alu's available, which is almost ubiquitous on x86),
> and only a negligible decrease on hardware that has only a single alu (an extra
> addition is introduced).  Since addition in commutative, the result is the same,
> only faster

On hardware that implement ADCX/ADOX then you should also be able to
have additional streams interleaved since those instructions allow for
dual carry chains.

	-hpa




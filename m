Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaA1MJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:09:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaA1MJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:09:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>, dmaengine@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v3 2/2] dmaengine: qcom_bam_dma: Add device tree binding
Date: Tue, 28 Jan 2014 13:08:47 +0100
Message-ID: <9156959.vu4XdoKglI@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <4916428.f0GtxdkWKj@wuerfel>
References: <1390890471-14882-1-git-send-email-agross@codeaurora.org> <20140128113242.GJ10628@intel.com> <4916428.f0GtxdkWKj@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GOOsqVkMm5aESw61AgA68O2rkYIoBqWKPtolcoH2AvW
 /wCu7hqU2qkuhm1VnpbnCFVBAj22p398iZHG1IYseUwMucFNtT
 r8nPLtS4+KcH52OiDTQewC6RzIq1v9hG0XuK611D2Fbhz/rKuK
 XxnXaey3l8OK/qlaGiFMuLVU5jzInm5QHZABoudcNOG6gMtB7y
 oS1DJZsxiIuKL7vtTYERpQfAKbgmCA8NgERADDnYe80ui1R9w+
 iOQJIyTifKEXaifUtasG6xXf4mugMkJj5CQFBO4u3/zB+sly3g
 5XIme4XmfFe0FKYeYgirWHKfUIwarbyLls+z+eTPN/LWkXzwwz
 pn+tbCpLKMXEL1X8XyAo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 January 2014 13:05:10 Arnd Bergmann wrote:
> On Tuesday 28 January 2014 17:02:42 Vinod Koul wrote:
> > On Tue, Jan 28, 2014 at 11:17:57AM +0000, Russell King - ARM Linux wrote:
> > > On Tue, Jan 28, 2014 at 10:16:53AM +0100, Arnd Bergmann wrote:
> > > > On Tuesday 28 January 2014 10:05:35 Lars-Peter Clausen wrote:
> > > > > Why does the direction needs to be specified in specifier? I see two
> > > > > options, either the direction per is fixed in hardware. In that case the DMA
> > > > > controller node should describe which channel is which direction. Or the
> > > > > direction is not fixed in hardware and can be changed at runtime in which
> > > > > case it should be set on a per descriptor basis.
> > > > 
> > > > Normally the direction is implied by dmaengine_slave_config().
> > > 
> > > No.  The direction argument in there is deprecated - we've been talking
> > > about removing it for some time.
> > > 
> > > DMA engine drivers should store all parameters of the configuration, and
> > > then select the appropriate ones when preparing a transfer (which itself
> > > involves a direction.)
> > 
> > Right all the prep_ calls for slave cases have explcit direction argument so
> > sending it using slave config makes no sense. So will remove it after the merge
> > window closes and fix 
> 
> Ok, thanks for clearing up my mistake. However, the argument remains:
> the direction doesn't need to be in the DT DMA descriptor since it
> gets set by software anyway.

On a related note, should we try to remove the slave_id field from
the slave config structure as well? I believe it is still used by
the shmobile dma engine in non-DT mode, but that is inconsistent with
how all the others work, and with what the same driver does for DT.

	Arnd

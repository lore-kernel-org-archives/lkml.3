Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaCXK7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:59:53 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:36429 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaCXK7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:59:51 -0400
Message-ID: <53301023.8080301@monstr.eu>
Date: Mon, 24 Mar 2014 11:59:47 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>
CC: Srikanth Thokala <sthokal@xilinx.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
References: <1395083192-3224-1-git-send-email-sthokal@xilinx.com> <1395083192-3224-3-git-send-email-sthokal@xilinx.com> <CABb+yY1z1Rr-EyJaeHQDb+thmKZVk5V93avokx6Z_EEuQFHyrw@mail.gmail.com> <CA+mB=1Lwq=Z3E+K7KTCgDKdmEQ8s5DMsAQVLVijdNPknNzx+SA@mail.gmail.com> <CAJe_Zhdnz+bdFiAqPgdH5hOTfzYUsoMyd0qpoWkeDAqqU+itSQ@mail.gmail.com>
In-Reply-To: <CAJe_Zhdnz+bdFiAqPgdH5hOTfzYUsoMyd0qpoWkeDAqqU+itSQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="S05dd2pJMCUtcj1SChpUGnf4mcBDeAdXn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S05dd2pJMCUtcj1SChpUGnf4mcBDeAdXn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

sorry for top posting.

is there any chance to get this driver to the 3.15?
Or have you already closed your dma repo for new drivers?

The driver should be in pretty good shape after long review.
=46rom email below Srikanth got ACK from Jassi
and there should be a small fix which Srikanth will send in v7
which I hope will be the last version.

Thanks,
Michal

On 03/24/2014 11:51 AM, Jassi Brar wrote:
> On 24 March 2014 14:30, Srikanth Thokala <sthokal@xilinx.com> wrote:
>> Hi Jassi,
>>
>> Thanks for the Acked-by.
>>
>> On Mon, Mar 24, 2014 at 11:50 AM, Jassi Brar <jassisinghbrar@gmail.com=
> wrote:
>>> On Tue, Mar 18, 2014 at 12:36 AM, Srikanth Thokala <sthokal@xilinx.co=
m> wrote:
>>>
>>>> +
>>>> +/**
>>>> + * xilinx_vdma_prep_slave_sg - prepare a descriptor for a DMA_SLAVE=
 transaction
>>>
>>> Should be xilinx_vdma_dma_prep_interleaved here.
>>
>> Ok, I will correct it.  Thanks.
>>
>>>
>>>> +/**
>>>> + * xilinx_vdma_channel_set_config - Configure VDMA channel
>>>> + * Run-time configuration for Axi VDMA, supports:
>>>> + * . halt the channel
>>>> + * . configure interrupt coalescing and inter-packet delay threshol=
d
>>>> + * . start/stop parking
>>>> + * . enable genlock
>>>> + *
>>>> + * @dchan: DMA channel
>>>> + * @cfg: VDMA device configuration pointer
>>>> + *
>>>> + * Return: '0' on success and failure value on error
>>>> + */
>>>> +int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
>>>> +                                       struct xilinx_vdma_config *c=
fg)
>>>> +{
>>>> +       struct xilinx_vdma_chan *chan =3D to_xilinx_chan(dchan);
>>>> +       u32 dmacr;
>>>> +
>>>> +       if (cfg->reset)
>>>> +               return xilinx_vdma_chan_reset(chan);
>>>> +
>>>> +       dmacr =3D vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR);
>>>> +
>>>> +       chan->config.frm_dly =3D cfg->frm_dly;
>>>> +       chan->config.park =3D cfg->park;
>>>> +
>>>> +       /* genlock settings */
>>>> +       chan->config.gen_lock =3D cfg->gen_lock;
>>>> +       chan->config.master =3D cfg->master;
>>>> +
>>>> +       if (cfg->gen_lock && chan->genlock) {
>>>> +               dmacr |=3D XILINX_VDMA_DMACR_GENLOCK_EN;
>>>> +               dmacr |=3D cfg->master << XILINX_VDMA_DMACR_MASTER_S=
HIFT;
>>>> +       }
>>>> +
>>>> +       chan->config.frm_cnt_en =3D cfg->frm_cnt_en;
>>>> +       if (cfg->park)
>>>> +               chan->config.park_frm =3D cfg->park_frm;
>>>> +       else
>>>> +               chan->config.park_frm =3D -1;
>>>> +
>>>> +       chan->config.coalesc =3D cfg->coalesc;
>>>> +       chan->config.delay =3D cfg->delay;
>>>> +
>>>> +       if (cfg->coalesc <=3D XILINX_VDMA_DMACR_FRAME_COUNT_MAX) {
>>>> +               dmacr |=3D cfg->coalesc << XILINX_VDMA_DMACR_FRAME_C=
OUNT_SHIFT;
>>>> +               chan->config.coalesc =3D cfg->coalesc;
>>>> +       }
>>>> +
>>>> +       if (cfg->delay <=3D XILINX_VDMA_DMACR_DELAY_MAX) {
>>>> +               dmacr |=3D cfg->delay << XILINX_VDMA_DMACR_DELAY_SHI=
FT;
>>>> +               chan->config.delay =3D cfg->delay;
>>>> +       }
>>>> +
>>>> +       /* FSync Source selection */
>>>> +       dmacr &=3D ~XILINX_VDMA_DMACR_FSYNCSRC_MASK;
>>>> +       dmacr |=3D cfg->ext_fsync << XILINX_VDMA_DMACR_FSYNCSRC_SHIF=
T;
>>>> +
>>>> +       vdma_ctrl_write(chan, XILINX_VDMA_REG_DMACR, dmacr);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +EXPORT_SYMBOL(xilinx_vdma_channel_set_config);
>>>> +
>>> Bypassing the DMAEngine api doesn't seem very neat.
>>> Is there currently any client driver that /changes/ this configuratio=
n
>>> between channel requests? If no, then simply get the configuration
>>> from DT node and avoid this api.
>>
>> This change is recently suggested by Lars in the following patch serie=
s,
>> "dma: Remove comment about embedding dma_slave_config into custom stru=
cts"
>>
> If some user does indeed need to /change/ the configuration across
> channel requests, we can keep function. Is there currently any such
> user?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--S05dd2pJMCUtcj1SChpUGnf4mcBDeAdXn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMwECMACgkQykllyylKDCG9awCfQ1VA9WEZMqS2eCsxxUtX/LwL
KYsAn3aA3qsuPBrWEsPxgOG16mlvhyQq
=oSSE
-----END PGP SIGNATURE-----

--S05dd2pJMCUtcj1SChpUGnf4mcBDeAdXn--

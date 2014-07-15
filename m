Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbaGONKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:10:41 -0400
Received: from mout.web.de ([212.227.17.12]:52282 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219AbaGONKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:10:39 -0400
Message-ID: <53C52837.4030105@web.de>
Date: Tue, 15 Jul 2014 15:10:15 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@minantech.com>, Tang Chen <tangchen@cn.fujitsu.com>
CC: mtosatti@redhat.com, nadav.amit@gmail.com, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page
 in memory.
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com> <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com> <20140712080442.GH4399@minantech.com> <53C38D55.2040307@cn.fujitsu.com> <20140714145822.GK4399@minantech.com> <53C51608.4080109@web.de> <20140715120921.GT18167@minantech.com> <53C51E66.7030208@cn.fujitsu.com> <20140715124048.GU18167@minantech.com>
In-Reply-To: <20140715124048.GU18167@minantech.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ndPCTSEi3KP8GNFciBjsIURkx5bTXBXxf"
X-Provags-ID: V03:K0:SriIK7GZ7tosTXGlH/0GTae0H6Kcg50cXy/jND76RXffSur1711
 FlO6PiXBG+h8uHSTo7qUJvMbN8H/TsNP48gqENk5pmg0lKp+ZV+k0hQTcDpZqYwzJVSkCh3
 pFrT5ruahFqjSZbSfafTnWvw7+MA7D0jLfsM9Au/FgSDbzUGJJ+Wx4Yq2xSDQAojDovoHaY
 OGt86x8/b5/hATc68KllQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ndPCTSEi3KP8GNFciBjsIURkx5bTXBXxf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-07-15 14:40, Gleb Natapov wrote:
>>
>> ......
>> 7922                         if (!vmx->nested.apic_access_page)
>> 7923                                 exec_control &=3D
>> 7924 ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
>> 7925                         else
>> 7926                                 vmcs_write64(APIC_ACCESS_ADDR,
>> 7927 page_to_phys(vmx->nested.apic_access_page));
>> 7928                 } else if
>> (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
>> 7929                         exec_control |=3D
>> 7930 SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
>> 7931                         vmcs_write64(APIC_ACCESS_ADDR,
>> 7932 page_to_phys(vcpu->kvm->arch.apic_access_page));
>> 7933                 }
>>
>> And yes, we have the problem you said here. We can migrate the page wh=
ile L2
>> vm is running.
>> So I think we should enforce L2 vm to exit to L1. Right ?
>>
> We can request APIC_ACCESS_ADDR reload during L2->L1 vmexit emulation, =
so
> if APIC_ACCESS_ADDR changes while L2 is running it will be reloaded for=
 L1 too.

How should this host-managed VMCS field possibly change while L2 is runni=
ng?

Jan



--ndPCTSEi3KP8GNFciBjsIURkx5bTXBXxf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPFKDcACgkQitSsb3rl5xSrDACdG7B6LVBlptPxtgXqfiGBLqPJ
0f0AoJIkj+w1FOdKa+QZnqRUAfP+MIrC
=EQGb
-----END PGP SIGNATURE-----

--ndPCTSEi3KP8GNFciBjsIURkx5bTXBXxf--

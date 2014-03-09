Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaCIILq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:11:46 -0400
Received: from mout.web.de ([212.227.15.4]:56590 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaCIILl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:11:41 -0400
Message-ID: <531C2238.1060202@web.de>
Date: Sun, 09 Mar 2014 09:11:36 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org
Subject: Re: [PATCH 0/7] KVM: x86: Let the guest write to multiple debug registers
 with one vmexit
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VdgwEv3un76m9KLC7PKQvHFStEOgeObtp"
X-Provags-ID: V03:K0:xuIgFlf36IQQlNQQVCa8n2kucvkMMkNye30aPUQK7rtw4Wbid1a
 3STg6MWVzsydLInb++QjntLjraz21zASwaJBY6qBMZAueNrGCNO74dWcJL2VQDJMGj26Hdr
 WPRQ8mlMZM4dECwrzbTXGlwjFcjdr/9nz27SOq+21C7e46CeA7ZhWeiOdHY+LE0Cp8P7bNk
 gM8fixLV+iE/RIzMF4VDw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VdgwEv3un76m9KLC7PKQvHFStEOgeObtp
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2014-03-07 12:42, Paolo Bonzini wrote:
> Alex Williamson reported that a Windows game does something weird that
> makes the guest save and restore debug registers on each context switch=
=2E
> This cause several hundred thousands vmexits per second, and basically
> cuts performance in half when running under KVM.
>=20
> However, when not running in guest-debug mode, the guest controls the
> debug registers and having to take an exit for each DR access is a wast=
e
> of time.  We just need one vmexit to load any stale values of DR0-DR6,
> and then we can let the guest run freely.  On the next vmexit (whatever=

> the reason) we will read out whatever changes the guest made to the
> debug registers.
>=20
> Tested with x86/debug.flat on both Intel and AMD, both direct and
> nested virtualization.
>=20
> Changes from RFC: changed get_dr7 callback to sync_dirty_debug_regs,
> 	new patches 5-7.

This looks good now to me from KVM perspective. I was just wondering how
the case is handled that the host used debug registers on the thread the
runs a VCPU? What if I set a hw breakpoint on its userspace path e.g.?
What if I debug the kernel side with kgdb?

Jan

>=20
> Paolo Bonzini (7):
>   KVM: vmx: we do rely on loading DR7 on entry
>   KVM: x86: change vcpu->arch.switch_db_regs to a bit mask
>   KVM: x86: Allow the guest to run with dirty debug registers
>   KVM: vmx: Allow the guest to run with dirty debug registers
>   KVM: nVMX: Allow nested guests to run with dirty debug registers
>   KVM: svm: set/clear all DR intercepts in one swoop
>   KVM: svm: Allow the guest to run with dirty debug registers
>=20
>  arch/x86/include/asm/kvm_host.h |  8 ++++-
>  arch/x86/kvm/svm.c              | 68 ++++++++++++++++++++++++++++-----=
--------
>  arch/x86/kvm/vmx.c              | 43 ++++++++++++++++++++++++--
>  arch/x86/kvm/x86.c              | 20 +++++++++++-
>  4 files changed, 114 insertions(+), 25 deletions(-)
>=20



--VdgwEv3un76m9KLC7PKQvHFStEOgeObtp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMcIjgACgkQitSsb3rl5xQz7ACfUc6aYzg6QrzHObafVbVEuQRh
8hQAn1ZGSPGASzX4JLfz1ojuYyd4lxLw
=Dita
-----END PGP SIGNATURE-----

--VdgwEv3un76m9KLC7PKQvHFStEOgeObtp--

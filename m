Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaCIIP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:15:57 -0400
Received: from mout.web.de ([212.227.15.4]:58450 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaCIIPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:15:47 -0400
Message-ID: <531C232D.40200@web.de>
Date: Sun, 09 Mar 2014 09:15:41 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org
Subject: Re: [PATCH 0/7] KVM: x86: Let the guest write to multiple debug registers
 with one vmexit
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com> <531C2238.1060202@web.de>
In-Reply-To: <531C2238.1060202@web.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SbL4WOktpGJsjJ3k7ohtvE6HcQnrVChD7"
X-Provags-ID: V03:K0:NoM0V5UuwaXr1rmwPSFy8nQkBdggUWYalfuPAZXFb6Wrg/I078Y
 pNLKaV2g1VUqNlBiBa9vNRL50FthGb5aJpuob5knhnaGHV8k8syaiXwXhrhj3fnyyDiGJif
 O54aiDqnJN5yLD7vmsloj9tGIPLkSGY28DRVDq9hL1R0lkIogAQ75593b2g4tjJ3px8y9Jr
 bxG5ovTrStHLKJDmewgHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SbL4WOktpGJsjJ3k7ohtvE6HcQnrVChD7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2014-03-09 09:11, Jan Kiszka wrote:
> On 2014-03-07 12:42, Paolo Bonzini wrote:
>> Alex Williamson reported that a Windows game does something weird that=

>> makes the guest save and restore debug registers on each context switc=
h.
>> This cause several hundred thousands vmexits per second, and basically=

>> cuts performance in half when running under KVM.
>>
>> However, when not running in guest-debug mode, the guest controls the
>> debug registers and having to take an exit for each DR access is a was=
te
>> of time.  We just need one vmexit to load any stale values of DR0-DR6,=

>> and then we can let the guest run freely.  On the next vmexit (whateve=
r
>> the reason) we will read out whatever changes the guest made to the
>> debug registers.
>>
>> Tested with x86/debug.flat on both Intel and AMD, both direct and
>> nested virtualization.
>>
>> Changes from RFC: changed get_dr7 callback to sync_dirty_debug_regs,
>> 	new patches 5-7.
>=20
> This looks good now to me from KVM perspective. I was just wondering ho=
w
> the case is handled that the host used debug registers on the thread th=
e
> runs a VCPU? What if I set a hw breakpoint on its userspace path e.g.?
> What if I debug the kernel side with kgdb?

Ah, this part didn't change, we still switch between host and guest
state on vmentries/exits. All fine!

Jan



--SbL4WOktpGJsjJ3k7ohtvE6HcQnrVChD7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMcIy0ACgkQitSsb3rl5xQpoACaAx2oAMVCz2vgzi8BcYnXdtcW
Nn0AoNKKfA4p5lRFuvFtqZTTZvf07Yk3
=G1ux
-----END PGP SIGNATURE-----

--SbL4WOktpGJsjJ3k7ohtvE6HcQnrVChD7--

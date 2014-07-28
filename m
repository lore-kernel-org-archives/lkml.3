Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaG1GxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:53:12 -0400
Received: from ozlabs.org ([103.22.144.67]:40067 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaG1GxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:53:10 -0400
Date: Mon, 28 Jul 2014 16:53:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: linux-next: manual merge of the kvm-ppc tree with the kvm tree
Message-ID: <20140728165300.164ae107@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//lz4HD=xsJephe.R8P4nHT/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//lz4HD=xsJephe.R8P4nHT/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
Documentation/virtual/kvm/api.txt between commit 8a366a4bae15 ("KVM:
s390: document KVM_CAP_S390_IRQCHIP") from the kvm tree and commit
dfc17cc2ded1 ("KVM: PPC: Book3S: Controls for in-kernel sPAPR hypercall
handling") from the kvm-ppc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/virtual/kvm/api.txt
index 68cda1fc3d52,69553183ef0f..000000000000
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@@ -2931,13 -2863,12 +2931,13 @@@ The fields in each entry are defined a
           this function/index combination
 =20
 =20
- 6. Capabilities that can be enabled
- -----------------------------------
+ 6. Capabilities that can be enabled on vCPUs
+ --------------------------------------------
 =20
 -There are certain capabilities that change the behavior of the virtual CP=
U when
 -enabled. To enable them, please see section 4.37. Below you can find a li=
st of
 -capabilities and what their effect on the vCPU is when enabling them.
 +There are certain capabilities that change the behavior of the virtual CP=
U or
 +the virtual machine when enabled. To enable them, please see section 4.37.
 +Below you can find a list of capabilities and what their effect on the vC=
PU or
 +the virtual machine is when enabling them.
 =20
  The following information is provided along with the description:
 =20
@@@ -3083,11 -3003,43 +3083,51 @@@ Parameters: args[0] is the XICS device=20
 =20
  This capability connects the vcpu to an in-kernel XICS device.
 =20
 +6.8 KVM_CAP_S390_IRQCHIP
 +
 +Architectures: s390
 +Target: vm
 +Parameters: none
 +
 +This capability enables the in-kernel irqchip for s390. Please refer to
 +"4.24 KVM_CREATE_IRQCHIP" for details.
+=20
+ 7. Capabilities that can be enabled on VMs
+ ------------------------------------------
+=20
+ There are certain capabilities that change the behavior of the virtual
+ machine when enabled. To enable them, please see section 4.37. Below
+ you can find a list of capabilities and what their effect on the VM
+ is when enabling them.
+=20
+ The following information is provided along with the description:
+=20
+   Architectures: which instruction set architectures provide this ioctl.
+       x86 includes both i386 and x86_64.
+=20
+   Parameters: what parameters are accepted by the capability.
+=20
+   Returns: the return value.  General error numbers (EBADF, ENOMEM, EINVA=
L)
+       are not detailed, but errors with specific meanings are.
+=20
+=20
+ 7.1 KVM_CAP_PPC_ENABLE_HCALL
+=20
+ Architectures: ppc
+ Parameters: args[0] is the sPAPR hcall number
+ 	    args[1] is 0 to disable, 1 to enable in-kernel handling
+=20
+ This capability controls whether individual sPAPR hypercalls (hcalls)
+ get handled by the kernel or not.  Enabling or disabling in-kernel
+ handling of an hcall is effective across the VM.  On creation, an
+ initial set of hcalls are enabled for in-kernel handling, which
+ consists of those hcalls for which in-kernel handlers were implemented
+ before this capability was implemented.  If disabled, the kernel will
+ not to attempt to handle the hcall, but will always exit to userspace
+ to handle it.  Note that it may not make sense to enable some and
+ disable others of a group of related hcalls, but KVM does not prevent
+ userspace from doing that.
+=20
+ If the hcall number specified is not one that has an in-kernel
+ implementation, the KVM_ENABLE_CAP ioctl will fail with an EINVAL
+ error.

--Sig_//lz4HD=xsJephe.R8P4nHT/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT1fNSAAoJEMDTa8Ir7ZwV2OYP/0ViWdCF1h1mV/4kBrAWEZWe
AB4AO/Z3jcD25UDQOLScs8BF+9uy4DBwT/WKpe8ERNaJTmfBNJreCbj8/4SpVX6l
x7Gh7TK+ZGqnZ3PUFEPTsIAVyzdnPVkvMSCLXCuGa2hdhGxFfDsRZXpVnr4g0TAF
lDvxFYoU+ugfY/aPDwpptfTRCadkrMo6XazCV8UlhCL3caKxiDHbkUaWsBEY6Lbj
tjp8YEgklUHNN175lijY/fdutswJYs6hiSotN9kXqPHdjviVpPKub/PgOu273QRV
TnvfjPsQsuq7XDceusdRCuspCd6GeqhwxumYC9n2jTefgWPsJek5WhZ1/2fuXIDg
6lXpaYyvY31ZmPoRUQKd1PeoVWh5ndhI5S8WOUZrPhR/9eeN0NYRyv9umO998hx1
zPxkf2X6Q9M8D8r4NVTppwYmmagbmJoTkP0dqbHphX74jPfF+nIVp/lE8eX3/w8h
6PHT0UNpU0api5cCskWba15svkHtfs0ZdnzNpLEmsfET2gBztKzki1OO2owtEF55
GfQ6Va6M65RoWXmYN7a5FcyN56/ObSpptaKpvuM2g8kkrZddv6ABcOAvPBFpmO7U
f9R10hubGaEMoygiSqE/lUosT87miJs23Ub4NYEaS7Hu1ITGYvV+7scBztmH/cHd
LFz8GpOZGgmeQZRHLS7S
=krNN
-----END PGP SIGNATURE-----

--Sig_//lz4HD=xsJephe.R8P4nHT/--

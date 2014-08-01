Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaHAOij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:38:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaHAOih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:38:37 -0400
Message-ID: <53DBA647.5050702@redhat.com>
Date: Fri, 01 Aug 2014 16:37:59 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-doc@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 3/5] mm, shmem: Add shmem_vma() helper
References: <1406036632-26552-1-git-send-email-jmarchan@redhat.com> <1406036632-26552-4-git-send-email-jmarchan@redhat.com> <alpine.LSU.2.11.1407312202040.3912@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1407312202040.3912@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2cQbduG131xhmjaDiKFBGTpv3g0eo95pU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2cQbduG131xhmjaDiKFBGTpv3g0eo95pU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/01/2014 07:03 AM, Hugh Dickins wrote:
> On Tue, 22 Jul 2014, Jerome Marchand wrote:
>=20
>> Add a simple helper to check if a vm area belongs to shmem.
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>>  include/linux/mm.h | 6 ++++++
>>  mm/shmem.c         | 8 ++++++++
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 34099fa..04a58d1 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -1074,11 +1074,17 @@ int shmem_zero_setup(struct vm_area_struct *);=

>> =20
>>  extern int shmem_locate(struct vm_area_struct *vma, pgoff_t pgoff, in=
t *count);
>>  bool shmem_mapping(struct address_space *mapping);
>> +bool shmem_vma(struct vm_area_struct *vma);
>> +
>>  #else
>>  static inline bool shmem_mapping(struct address_space *mapping)
>>  {
>>  	return false;
>>  }
>> +static inline bool shmem_vma(struct vm_area_struct *vma)
>> +{
>> +	return false;
>> +}
>>  #endif
>=20
> I would prefer include/linux/shmem_fs.h for this (and one of us clean
> up where the declarations of shmem_zero_setup and shmem_mapping live).
>=20
> But if 4/5 goes away, then there will only be one user of shmem_vma(),
> so in that case better just declare it (using shmem_mapping()) there
> in task_mmu.c in the smaps patch.
>=20
>> =20
>>  extern int can_do_mlock(void);
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 8aa4892..7d16227 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1483,6 +1483,14 @@ bool shmem_mapping(struct address_space *mappin=
g)
>>  	return mapping->backing_dev_info =3D=3D &shmem_backing_dev_info;
>>  }
>> =20
>> +bool shmem_vma(struct vm_area_struct *vma)
>> +{
>> +	return (vma->vm_file &&
>> +		vma->vm_file->f_dentry->d_inode->i_mapping->backing_dev_info
>> +		=3D=3D &shmem_backing_dev_info);
>> +
>=20
> I agree with Oleg,
> 	vma->vm_file && shmem_mapping(file_inode(vma->vm_file)->i_mapping);
> would be better,

Will do.

Jerome

>=20
> Hugh
>=20



--2cQbduG131xhmjaDiKFBGTpv3g0eo95pU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT26ZHAAoJEHTzHJCtsuoCTC0IALkb4dhI485soQTr3b5iNHMQ
9xW0ifj0MHPAF6EC0e/+ZUkYfY3ltXuHzJ/I9qkGNQHOpNS7qUOQ9LXrSH3phS72
kpOiq6LameOjqbyHIFYLWtDgwCNB4CogzulaWIEGiuPDnxtl0jUxhzKpZ3T+s+31
DVshjrbhJqorgz+NBqchYIcLNlMohzGP7n5ZUGYvozVK7QFfVhrVwT3nzP1612Ux
D05tDL5cdRwMpCLf+wLbkZyHVfOTzwvkjymCl1LU/NNMuDGHWCB9FRhloHKTRHau
FEuuP3WqH1sN3axr4wwrTdSxq5qF5Noy/UWoCdjOiIr8KzzJ0541K0RthN0FCzQ=
=b1sL
-----END PGP SIGNATURE-----

--2cQbduG131xhmjaDiKFBGTpv3g0eo95pU--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaIDXDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:03:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:33612 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaIDXDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:03:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,469,1406617200"; 
   d="asc'?scan'208";a="475307059"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michal Nazarewicz" <mina86@mina86.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: kernel: Resolve a shadow warning
Thread-Topic: kernel: Resolve a shadow warning
Thread-Index: AQHPyIiZ5cKygjV5+EmI8U1gWOl8vZvyDRqA
Date: Thu, 4 Sep 2014 23:03:17 +0000
Message-ID: <E40EB38B-3532-4856-AF83-4709D32F71D5@intel.com>
References: <1409837300.2460.10.camel@jtkirshe-mobl>
 <20140904143833.434f9e27765b74c90c91798e@linux-foundation.org>
In-Reply-To: <20140904143833.434f9e27765b74c90c91798e@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.80]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_39202711-9852-436F-B590-7338CAFE584B";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_39202711-9852-436F-B590-7338CAFE584B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 4, 2014, at 2:38 PM, Andrew Morton <akpm@linux-foundation.org> =
wrote:

>> From: Mark Rustad <mark.d.rustad@intel.com>
>>=20
>> Resolve a shadow warning in W=3D2 builds arising from min/max macro
>> references in a parameter to a min3/max3 macro. There is no
>> functional issue - the warning is benign - but simply changing
>> some local variable names will eliminate it.
>>=20
>> ...
>>=20
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -716,22 +716,22 @@ static inline void ftrace_dump(enum =
ftrace_dump_mode oops_dump_mode) { }
>> 	_max1 > _max2 ? _max1 : _max2; })
>>=20
>> #define min3(x, y, z) ({			\
>> -	typeof(x) _min1 =3D (x);			\
>> -	typeof(y) _min2 =3D (y);			\
>> -	typeof(z) _min3 =3D (z);			\
>> -	(void) (&_min1 =3D=3D &_min2);		\
>> -	(void) (&_min1 =3D=3D &_min3);		\
>> -	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
>> -		(_min2 < _min3 ? _min2 : _min3); })
>> +	typeof(x) _min31 =3D (x);			\
>> +	typeof(y) _min32 =3D (y);			\
>> +	typeof(z) _min33 =3D (z);			\
>> +	(void) (&_min31 =3D=3D &_min32);		\
>> +	(void) (&_min31 =3D=3D &_min33);		\
>> +	_min31 < _min32 ? (_min31 < _min33 ? _min31 : _min33) : \
>> +		(_min32 < _min33 ? _min32 : _min33); })
>>=20
>> #define max3(x, y, z) ({			\
>> -	typeof(x) _max1 =3D (x);			\
>> -	typeof(y) _max2 =3D (y);			\
>> -	typeof(z) _max3 =3D (z);			\
>> -	(void) (&_max1 =3D=3D &_max2);		\
>> -	(void) (&_max1 =3D=3D &_max3);		\
>> -	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
>> -		(_max2 > _max3 ? _max2 : _max3); })
>> +	typeof(x) _max31 =3D (x);			\
>> +	typeof(y) _max32 =3D (y);			\
>> +	typeof(z) _max33 =3D (z);			\
>> +	(void) (&_max31 =3D=3D &_max32);		\
>> +	(void) (&_max31 =3D=3D &_max33);		\
>> +	_max31 > _max32 ? (_max31 > _max33 ? _max31 : _max33) : \
>> +		(_max32 > _max33 ? _max32 : _max33); })
>>=20
>> /**
>>  * min_not_zero - return the minimum that is _not_ zero, unless both =
are zero
>=20
> I'm still sitting on the below patch.  It's stalled because I have a
> note that David potentially found issues with it.  But on rechecking,
> that appears to be stale, or not serious enough to prevent inclusion.
>=20
> I can't (be bothered to) check whether this patch fixes the warnings
> because your changelog didn't tell me how to trigger the warnings (bad
> changelog).  But it might fix them!  Can you please test it?

Actually it does. W=3D2 builds get warnings when a min/max macro is used =
as a parameter to min3/max3. If you move to the min3/max3 that makes =
nested calls to min/max, every reference to min3/max3 will generate a =
warning in W=3D2 builds no matter what. It is interesting that the =
compiler optimizes that better - I hadn't looked at that.

Not wanting to argue for poorer code, lets forget about the warnings for =
now. These particular shadow warnings are pretty trivial. I'll consider =
revisiting it later. And next time I'll check the code generation.

> From: Michal Nazarewicz <mina86@mina86.com>
> Subject: include/linux/kernel.h: rewrite min3, max3 and clamp using =
min and max
>=20
> It appears that gcc is better at optimising a double call to min and =
max
> rather than open coded min3 and max3.  This can be observed here:
>=20
>    $ cat min-max.c
>    #define min(x, y) ({				\
>    	typeof(x) _min1 =3D (x);			\
>    	typeof(y) _min2 =3D (y);			\
>    	(void) (&_min1 =3D=3D &_min2);		\
>    	_min1 < _min2 ? _min1 : _min2; })
>    #define min3(x, y, z) ({			\
>    	typeof(x) _min1 =3D (x);			\
>    	typeof(y) _min2 =3D (y);			\
>    	typeof(z) _min3 =3D (z);			\
>    	(void) (&_min1 =3D=3D &_min2);		\
>    	(void) (&_min1 =3D=3D &_min3);		\
>    	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
>    		(_min2 < _min3 ? _min2 : _min3); })
>=20
>    int fmin3(int x, int y, int z) { return min3(x, y, z); }
>    int fmin2(int x, int y, int z) { return min(min(x, y), z); }
>=20
>    $ gcc -O2 -o min-max.s -S min-max.c; cat min-max.s
>    	.file	"min-max.c"
>    	.text
>    	.p2align 4,,15
>    	.globl	fmin3
>    	.type	fmin3, @function
>    fmin3:
>    .LFB0:
>    	.cfi_startproc
>    	cmpl	%esi, %edi
>    	jl	.L5
>    	cmpl	%esi, %edx
>    	movl	%esi, %eax
>    	cmovle	%edx, %eax
>    	ret
>    	.p2align 4,,10
>    	.p2align 3
>    .L5:
>    	cmpl	%edi, %edx
>    	movl	%edi, %eax
>    	cmovle	%edx, %eax
>    	ret
>    	.cfi_endproc
>    .LFE0:
>    	.size	fmin3, .-fmin3
>    	.p2align 4,,15
>    	.globl	fmin2
>    	.type	fmin2, @function
>    fmin2:
>    .LFB1:
>    	.cfi_startproc
>    	cmpl	%edi, %esi
>    	movl	%edx, %eax
>    	cmovle	%esi, %edi
>    	cmpl	%edx, %edi
>    	cmovle	%edi, %eax
>    	ret
>    	.cfi_endproc
>    .LFE1:
>    	.size	fmin2, .-fmin2
>    	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
>    	.section	.note.GNU-stack,"",@progbits
>=20
> fmin3 function, which uses open-coded min3 macro, is compiled into =
total
> of ten instructions including a conditional branch, whereas fmin2
> function, which uses two calls to min2 macro, is compiled into six
> instructions with no branches.
>=20
> Similarly, open-coded clamp produces the same code as clamp using min =
and
> max macros, but the latter is much shorter:
>=20
>    $ cat clamp.c
>    #define clamp(val, min, max) ({			\
>    	typeof(val) __val =3D (val);		\
>    	typeof(min) __min =3D (min);		\
>    	typeof(max) __max =3D (max);		\
>    	(void) (&__val =3D=3D &__min);		\
>    	(void) (&__val =3D=3D &__max);		\
>    	__val =3D __val < __min ? __min: __val;	\
>    	__val > __max ? __max: __val; })
>    #define min(x, y) ({				\
>    	typeof(x) _min1 =3D (x);			\
>    	typeof(y) _min2 =3D (y);			\
>    	(void) (&_min1 =3D=3D &_min2);		\
>    	_min1 < _min2 ? _min1 : _min2; })
>    #define max(x, y) ({				\
>    	typeof(x) _max1 =3D (x);			\
>    	typeof(y) _max2 =3D (y);			\
>    	(void) (&_max1 =3D=3D &_max2);		\
>    	_max1 > _max2 ? _max1 : _max2; })
>=20
>    int fclamp(int v, int min, int max) { return clamp(v, min, max); }
>    int fclampmm(int v, int min, int max) { return min(max(v, min), =
max); }
>=20
>    $ gcc -O2 -o clamp.s -S clamp.c; cat clamp.s
>    	.file	"clamp.c"
>    	.text
>    	.p2align 4,,15
>    	.globl	fclamp
>    	.type	fclamp, @function
>    fclamp:
>    .LFB0:
>    	.cfi_startproc
>    	cmpl	%edi, %esi
>    	movl	%edx, %eax
>    	cmovge	%esi, %edi
>    	cmpl	%edx, %edi
>    	cmovle	%edi, %eax
>    	ret
>    	.cfi_endproc
>    .LFE0:
>    	.size	fclamp, .-fclamp
>    	.p2align 4,,15
>    	.globl	fclampmm
>    	.type	fclampmm, @function
>    fclampmm:
>    .LFB1:
>    	.cfi_startproc
>    	cmpl	%edi, %esi
>    	cmovge	%esi, %edi
>    	cmpl	%edi, %edx
>    	movl	%edi, %eax
>    	cmovle	%edx, %eax
>    	ret
>    	.cfi_endproc
>    .LFE1:
>    	.size	fclampmm, .-fclampmm
>    	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
>    	.section	.note.GNU-stack,"",@progbits
>=20
>    Linux mpn-glaptop 3.13.0-29-generic #53~precise1-Ubuntu SMP Wed Jun =
4 22:06:25 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>    gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3
>    Copyright (C) 2011 Free Software Foundation, Inc.
>    This is free software; see the source for copying conditions.  =
There is NO
>    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR =
PURPOSE.
>=20
>    -rwx------ 1 mpn eng 51224656 Jun 17 14:15 vmlinux.before
>    -rwx------ 1 mpn eng 51224608 Jun 17 13:57 vmlinux.after
>=20
> 48 bytes reduction.  The do_fault_around was a few instruction shorter
> and as far as I can tell saved 12 bytes on the stack, i.e.:
>=20
>    $ grep -e rsp -e pop -e push do_fault_around.*
>    do_fault_around.before.s:push   %rbp
>    do_fault_around.before.s:mov    %rsp,%rbp
>    do_fault_around.before.s:push   %r13
>    do_fault_around.before.s:push   %r12
>    do_fault_around.before.s:push   %rbx
>    do_fault_around.before.s:sub    $0x38,%rsp
>    do_fault_around.before.s:add    $0x38,%rsp
>    do_fault_around.before.s:pop    %rbx
>    do_fault_around.before.s:pop    %r12
>    do_fault_around.before.s:pop    %r13
>    do_fault_around.before.s:pop    %rbp
>=20
>    do_fault_around.after.s:push   %rbp
>    do_fault_around.after.s:mov    %rsp,%rbp
>    do_fault_around.after.s:push   %r12
>    do_fault_around.after.s:push   %rbx
>    do_fault_around.after.s:sub    $0x30,%rsp
>    do_fault_around.after.s:add    $0x30,%rsp
>    do_fault_around.after.s:pop    %rbx
>    do_fault_around.after.s:pop    %r12
>    do_fault_around.after.s:pop    %rbp
>=20
> or here side-by-side:
>=20
>    Before                    After
>    push   %rbp               push   %rbp         =20
>    mov    %rsp,%rbp          mov    %rsp,%rbp    =20
>    push   %r13                                   =20
>    push   %r12               push   %r12         =20
>    push   %rbx               push   %rbx         =20
>    sub    $0x38,%rsp         sub    $0x30,%rsp   =20
>    add    $0x38,%rsp         add    $0x30,%rsp   =20
>    pop    %rbx               pop    %rbx         =20
>    pop    %r12               pop    %r12         =20
>    pop    %r13                                   =20
>    pop    %rbp               pop    %rbp         =20
>=20
> There are also fewer branches:
>=20
>    $ grep ^j do_fault_around.*
>    do_fault_around.before.s:jae    ffffffff812079b7
>    do_fault_around.before.s:jmp    ffffffff812079c5
>    do_fault_around.before.s:jmp    ffffffff81207a14
>    do_fault_around.before.s:ja     ffffffff812079f9
>    do_fault_around.before.s:jb     ffffffff81207a10
>    do_fault_around.before.s:jmp    ffffffff81207a63
>    do_fault_around.before.s:jne    ffffffff812079df
>=20
>    do_fault_around.after.s:jmp    ffffffff812079fd
>    do_fault_around.after.s:ja     ffffffff812079e2
>    do_fault_around.after.s:jb     ffffffff812079f9
>    do_fault_around.after.s:jmp    ffffffff81207a4c
>    do_fault_around.after.s:jne    ffffffff812079c8
>=20
> And here's with allyesconfig on a different machine:
>=20
>    $ uname -a; gcc --version; ls -l vmlinux.*
>    Linux erwin 3.14.7-mn #54 SMP Sun Jun 15 11:25:08 CEST 2014 x86_64 =
AMD Phenom(tm) II X3 710 Processor AuthenticAMD GNU/Linux
>    gcc (GCC) 4.8.3
>    Copyright (C) 2013 Free Software Foundation, Inc.
>    This is free software; see the source for copying conditions.  =
There is NO
>    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR =
PURPOSE.
>=20
>    -rwx------ 1 mpn eng 437027411 Jun 20 16:04 vmlinux.before
>    -rwx------ 1 mpn eng 437026881 Jun 20 15:30 vmlinux.after
>=20
> 530 bytes reduction.
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Hagen Paul Pfeifer <hagen@jauu.net>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
> include/linux/kernel.h |   32 +++++---------------------------
> 1 file changed, 5 insertions(+), 27 deletions(-)
>=20
> diff -puN =
include/linux/kernel.h~include-kernelh-rewrite-min3-max3-and-clamp-using-m=
in-and-max include/linux/kernel.h
> --- =
a/include/linux/kernel.h~include-kernelh-rewrite-min3-max3-and-clamp-using=
-min-and-max
> +++ a/include/linux/kernel.h
> @@ -715,23 +715,8 @@ static inline void ftrace_dump(enum ftra
> 	(void) (&_max1 =3D=3D &_max2);		\
> 	_max1 > _max2 ? _max1 : _max2; })
>=20
> -#define min3(x, y, z) ({			\
> -	typeof(x) _min1 =3D (x);			\
> -	typeof(y) _min2 =3D (y);			\
> -	typeof(z) _min3 =3D (z);			\
> -	(void) (&_min1 =3D=3D &_min2);		\
> -	(void) (&_min1 =3D=3D &_min3);		\
> -	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
> -		(_min2 < _min3 ? _min2 : _min3); })
> -
> -#define max3(x, y, z) ({			\
> -	typeof(x) _max1 =3D (x);			\
> -	typeof(y) _max2 =3D (y);			\
> -	typeof(z) _max3 =3D (z);			\
> -	(void) (&_max1 =3D=3D &_max2);		\
> -	(void) (&_max1 =3D=3D &_max3);		\
> -	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
> -		(_max2 > _max3 ? _max2 : _max3); })
> +#define min3(x, y, z) min((typeof(x))min(x, y), z)
> +#define max3(x, y, z) max((typeof(x))max(x, y), z)
>=20
> /**
>  * min_not_zero - return the minimum that is _not_ zero, unless both =
are zero
> @@ -746,20 +731,13 @@ static inline void ftrace_dump(enum ftra
> /**
>  * clamp - return a value clamped to a given range with strict =
typechecking
>  * @val: current value
> - * @min: minimum allowable value
> - * @max: maximum allowable value
> + * @lo: lowest allowable value
> + * @hi: highest allowable value
>  *
>  * This macro does strict typechecking of min/max to make sure they =
are of the
>  * same type as val.  See the unnecessary pointer comparisons.
>  */
> -#define clamp(val, min, max) ({			\
> -	typeof(val) __val =3D (val);		\
> -	typeof(min) __min =3D (min);		\
> -	typeof(max) __max =3D (max);		\
> -	(void) (&__val =3D=3D &__min);		\
> -	(void) (&__val =3D=3D &__max);		\
> -	__val =3D __val < __min ? __min: __val;	\
> -	__val > __max ? __max: __val; })
> +#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
>=20
> /*
>  * ..and if you can't take the strict
> _
>=20

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_39202711-9852-436F-B590-7338CAFE584B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUCO+1AAoJEDwO/+eO4+5uyjEP/3ZRIwfDjhIhtytOTof6oo+S
9FU5sY0oeaqk9pP3R68UuadzYhTF+3k4OBPm2NeQr0Mr4XhylWUrdHgRvcZHtrSe
wybxeZ6Vgrd9+QIKPZb7EZe3HF1+jb1sjddexdMrk07dNWidG4fns9ZGrvAMfhgw
kBAbkPFIqhBNKr3KOKUGLwbTiW6e8+T9a7Jjiyg6IHINhgKy9J2rpOQNZpMO1J6i
Ro87aYvn23X+4co3FDLCIbYzrmyzB3kRY9mT7fI3e2/gadRigtkjCC5jDKGgcOCU
0cmhQw3cLhtHt0rmK8V+R+47bt+MwKorJ93cJUh6Vy7HG0I1MYiPRUPUVnG0Tm+k
mjZWLM3Quolwly6NeNQVj12GRabajILU2/S9Mr+dlJ9ijPHuRtRJ/ai9Q9GSWtZA
1GVz+ZoALQzOWs6x1Aa88Qv1HdEHaU5QvtMjNL/ISN9T0pbM8qELVMlJ3IrnqHZ2
AK4ioDPmmoA/Ni6k6BRNbeS3yODPhEY1Nbq6L2OE0lKdjYDuQ1/qaP7xSRNkt7ZF
W7cjOW7v1fyQgC0gtjYxIXxPTeKyh3Hd+jxjxH4gBpmoNcrJY1cLdevLpQhEzuI2
jedinlDYUITqgSPeV+t/68fwwtwsnIFOX3o8Uxasiut6Tz/8gbxdbYIS9g6h/NfK
jQu04UKMU2D3ZR4N4XIK
=Jauw
-----END PGP SIGNATURE-----

--Apple-Mail=_39202711-9852-436F-B590-7338CAFE584B--

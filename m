Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaJIQ1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:27:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56328 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaJIQ1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:27:40 -0400
Date: Thu, 9 Oct 2014 11:26:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Felipe Balbi <balbi@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141009162656.GE16002@saruman>
Reply-To: <balbi@ti.com>
References: <20140904184021.GA13421@saruman.home>
 <20140904191642.GJ5001@linux.vnet.ibm.com>
 <20140904192535.GJ13421@saruman.home>
 <20140904200403.GL13421@saruman.home>
 <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman>
 <20141008175707.GI22688@saruman>
 <20141008212938.GP22688@saruman>
 <20141009160138.GA2396@cmpxchg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+JUInw4efm7IfTNU"
Content-Disposition: inline
In-Reply-To: <20141009160138.GA2396@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+JUInw4efm7IfTNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Thu, Oct 09, 2014 at 12:01:38PM -0400, Johannes Weiner wrote:
> On Wed, Oct 08, 2014 at 04:29:38PM -0500, Felipe Balbi wrote:
> > Finally bisected it down to commit 139e561660fe11e0fc35e142a800df3dd7d0=
3e9d
> > (lib: radix_tree: tree node interface). Here's full bisect log:
> >=20
> > git bisect start
> > # good: [455c6fdbd219161bd09b1165f11699d6d73de11c] Linux 3.14
> > git bisect good 455c6fdbd219161bd09b1165f11699d6d73de11c
> > # bad: [1860e379875dfe7271c649058aeddffe5afd9d0d] Linux 3.15
> > git bisect bad 1860e379875dfe7271c649058aeddffe5afd9d0d
> > # bad: [74a475acea49459721ae4b062d3da68c74259009] SubmittingPatches: ad=
d style recommendation to use imperative descriptions
> > git bisect bad 74a475acea49459721ae4b062d3da68c74259009
> > # good: [c12e69c6aaf785fd307d05cb6f36ca0e7577ead7] Merge tag 'staging-3=
=2E15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
> > git bisect good c12e69c6aaf785fd307d05cb6f36ca0e7577ead7
> > # good: [0fc31966035d7a540c011b6c967ce8eae1db121b] Merge branch 'for-da=
vem' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
> > git bisect good 0fc31966035d7a540c011b6c967ce8eae1db121b
> > # good: [bdfc7cbdeef8cadba0e5793079ac0130b8e2220c] Merge branch 'mips-f=
or-linux-next' of git://git.linux-mips.org/pub/scm/ralf/upstream-sfr
> > git bisect good bdfc7cbdeef8cadba0e5793079ac0130b8e2220c
> > # good: [0f1b1e6d73cb989ce2c071edc57deade3b084dfe] Merge branch 'for-li=
nus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
> > git bisect good 0f1b1e6d73cb989ce2c071edc57deade3b084dfe
> > # good: [181e7d5d7bd7747e882e3ca89ecbf0fc3e72d0da] ixgbe: remove redund=
ant if clause from PTP work
> > git bisect good 181e7d5d7bd7747e882e3ca89ecbf0fc3e72d0da
> > # good: [59ecc26004e77e100c700b1d0da7502b0fdadb46] Merge git://git.kern=
el.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
> > git bisect good 59ecc26004e77e100c700b1d0da7502b0fdadb46
> > # good: [2b665e276c15ba7d9fc8cdd16931883a51ed13e4] fs/direct-io.c: remo=
ve redundant comparison
> > git bisect good 2b665e276c15ba7d9fc8cdd16931883a51ed13e4
> > # bad: [f412c97abef71026d8192ca8efca231f1e3906b3] mm, hugetlb: mark som=
e bootstrap functions as __init
> > git bisect bad f412c97abef71026d8192ca8efca231f1e3906b3
> > # good: [4e35f483850ba46b838adfd312b3052416e15204] mm, hugetlb: use vma=
_resv_map() map types
> > git bisect good 4e35f483850ba46b838adfd312b3052416e15204
> > # good: [6dbaf22ce1f1dfba33313198eb5bd989ae76dd87] mm: shmem: save one =
radix tree lookup when truncating swapped pages
> > git bisect good 6dbaf22ce1f1dfba33313198eb5bd989ae76dd87
> > # good: [91b0abe36a7b2b3b02d7500925a5f8455334f0e5] mm + fs: store shado=
w entries in page cache
> > git bisect good 91b0abe36a7b2b3b02d7500925a5f8455334f0e5
> > # bad: [139e561660fe11e0fc35e142a800df3dd7d03e9d] lib: radix_tree: tree=
 node interface
> > git bisect bad 139e561660fe11e0fc35e142a800df3dd7d03e9d
> > # good: [a528910e12ec7ee203095eb1711468a66b9b60b0] mm: thrash detection=
-based file cache sizing
> > git bisect good a528910e12ec7ee203095eb1711468a66b9b60b0
> > # first bad commit: [139e561660fe11e0fc35e142a800df3dd7d03e9d] lib: rad=
ix_tree: tree node interface
> >=20
> > I tried reverting that commit on v3.15 but it's non-trivial; I'll leave
> > that for tomorrow. Meanwhile, adding folks involved with that commit to
> > Cc list and another backtrace for reference:
> >=20
> > [  113.696647] Unable to handle kernel paging request at virtual addres=
s ffffffff
> > [  113.704370] pgd =3D c0004000
> > [  113.707276] [ffffffff] *pgd=3D9fef6821, *pte=3D00000000, *ppte=3D000=
00000
> > [  113.713998] Internal error: Oops: 17 [#1] SMP ARM
> > [  113.718912] Modules linked in: g_mass_storage usb_f_mass_storage lib=
composite configfs musb_dsps musb_hdrc musb_am335x
> > [  113.730144] CPU: 0 PID: 1368 Comm: file-storage Not tainted 3.17.0-0=
2899-g748eb79 #239
> > [  113.738410] task: de606e00 ti: dd0ba000 task.ti: dd0ba000
> > [  113.744060] PC is at find_get_entry+0x64/0x100
>=20
> Could you please provide the disassembly of that function?

here you go. It's ARM assembly however:

Dump of assembler code for function find_get_entry:
   0xc011da48 <+0>:	mov	r12, sp
   0xc011da4c <+4>:	push	{r4, r5, r6, r7, r8, r9, r11, r12, lr, pc}
   0xc011da50 <+8>:	sub	r11, r12, #4
   0xc011da54 <+12>:	sub	sp, sp, #16
   0xc011da58 <+16>:	push	{lr}		; (str lr, [sp, #-4]!)
   0xc011da5c <+20>:	bl	0xc000ef00 <__gnu_mcount_nc>
   0xc011da60 <+24>:	mov	r6, r0
   0xc011da64 <+28>:	mov	r7, r1
   0xc011da68 <+32>:	ldr	r2, [pc, #520]	; 0xc011dc78 <find_get_entry+560>
   0xc011da6c <+36>:	mov	r3, #0
   0xc011da70 <+40>:	mov	r1, r3
   0xc011da74 <+44>:	str	r2, [sp, #8]
   0xc011da78 <+48>:	str	r3, [sp]
   0xc011da7c <+52>:	mov	r2, r3
   0xc011da80 <+56>:	str	r3, [sp, #4]
   0xc011da84 <+60>:	ldr	r0, [pc, #496]	; 0xc011dc7c <find_get_entry+564>
   0xc011da88 <+64>:	mov	r3, #2
   0xc011da8c <+68>:	bl	0xc0095f88 <lock_acquire>
   0xc011da90 <+72>:	bl	0xc00a7b50 <debug_lockdep_rcu_enabled>
   0xc011da94 <+76>:	cmp	r0, #0
   0xc011da98 <+80>:	beq	0xc011daac <find_get_entry+100>
   0xc011da9c <+84>:	ldr	r4, [pc, #476]	; 0xc011dc80 <find_get_entry+568>
   0xc011daa0 <+88>:	ldrb	r3, [r4, #1]
   0xc011daa4 <+92>:	cmp	r3, #0
   0xc011daa8 <+96>:	beq	0xc011dbfc <find_get_entry+436>
   0xc011daac <+100>:	ldr	r8, [pc, #460]	; 0xc011dc80 <find_get_entry+568>
   0xc011dab0 <+104>:	add	r6, r6, #4
   0xc011dab4 <+108>:	mov	r5, #1
   0xc011dab8 <+112>:	mov	r0, r6
   0xc011dabc <+116>:	mov	r1, r7
   0xc011dac0 <+120>:	bl	0xc0364660 <radix_tree_lookup_slot>
   0xc011dac4 <+124>:	subs	r9, r0, #0
   0xc011dac8 <+128>:	beq	0xc011dc24 <find_get_entry+476>
   0xc011dacc <+132>:	ldr	r4, [r9]
   0xc011dad0 <+136>:	bl	0xc00a7b50 <debug_lockdep_rcu_enabled>
   0xc011dad4 <+140>:	cmp	r0, #0
   0xc011dad8 <+144>:	beq	0xc011dae8 <find_get_entry+160>
   0xc011dadc <+148>:	ldrb	r3, [r8, #2]
   0xc011dae0 <+152>:	cmp	r3, #0
   0xc011dae4 <+156>:	beq	0xc011dbcc <find_get_entry+388>
   0xc011dae8 <+160>:	cmp	r4, #0
   0xc011daec <+164>:	beq	0xc011dc24 <find_get_entry+476>
   0xc011daf0 <+168>:	tst	r4, #3
   0xc011daf4 <+172>:	bne	0xc011dc4c <find_get_entry+516>
   0xc011daf8 <+176>:	mov	r2, sp
   0xc011dafc <+180>:	bic	r3, r2, #8128	; 0x1fc0
   0xc011db00 <+184>:	bic	r3, r3, #63	; 0x3f
   0xc011db04 <+188>:	ldr	r2, [pc, #376]	; 0xc011dc84 <find_get_entry+572>
   0xc011db08 <+192>:	ldr	r3, [r3, #4]
   0xc011db0c <+196>:	and	r2, r2, r3
   0xc011db10 <+200>:	cmp	r2, #0
   0xc011db14 <+204>:	bne	0xc011dc68 <find_get_entry+544>
   0xc011db18 <+208>:	add	r3, r4, #16
   0xc011db1c <+212>:	mcr	15, 0, r2, cr7, cr10, {5}
   0xc011db20 <+216>:	mov	r2, #0
   0xc011db24 <+220>:	pld	[r3]
   0xc011db28 <+224>:	ldrex	r1, [r3]
   0xc011db2c <+228>:	teq	r1, r2
   0xc011db30 <+232>:	beq	0xc011db44 <find_get_entry+252>
   0xc011db34 <+236>:	add	r0, r1, r5
   0xc011db38 <+240>:	strex	r12, r0, [r3]
   0xc011db3c <+244>:	teq	r12, #0
   0xc011db40 <+248>:	bne	0xc011db28 <find_get_entry+224>
   0xc011db44 <+252>:	cmp	r1, #0
   0xc011db48 <+256>:	beq	0xc011dab8 <find_get_entry+112>
   0xc011db4c <+260>:	mov	r3, #0
   0xc011db50 <+264>:	mcr	15, 0, r3, cr7, cr10, {5}
   0xc011db54 <+268>:	ldr	r3, [r4]
   0xc011db58 <+272>:	tst	r3, #32768	; 0x8000
   0xc011db5c <+276>:	bne	0xc011dc58 <find_get_entry+528>
   0xc011db60 <+280>:	ldr	r3, [r9]
   0xc011db64 <+284>:	cmp	r3, r4
   0xc011db68 <+288>:	bne	0xc011dc6c <find_get_entry+548>
   0xc011db6c <+292>:	bl	0xc00a7b50 <debug_lockdep_rcu_enabled>
   0xc011db70 <+296>:	cmp	r0, #0
   0xc011db74 <+300>:	beq	0xc011db88 <find_get_entry+320>
   0xc011db78 <+304>:	ldr	r5, [pc, #256]	; 0xc011dc80 <find_get_entry+568>
   0xc011db7c <+308>:	ldrb	r3, [r5, #3]
   0xc011db80 <+312>:	cmp	r3, #0
   0xc011db84 <+316>:	beq	0xc011dba4 <find_get_entry+348>
   0xc011db88 <+320>:	ldr	r0, [pc, #236]	; 0xc011dc7c <find_get_entry+564>
   0xc011db8c <+324>:	mov	r1, #1
   0xc011db90 <+328>:	ldr	r2, [pc, #240]	; 0xc011dc88 <find_get_entry+576>
   0xc011db94 <+332>:	bl	0xc0096380 <lock_release>
   0xc011db98 <+336>:	sub	sp, r11, #36	; 0x24
   0xc011db9c <+340>:	mov	r0, r4
   0xc011dba0 <+344>:	ldm	sp, {r4, r5, r6, r7, r8, r9, r11, sp, pc}
   0xc011dba4 <+348>:	bl	0xc00aadc4 <rcu_is_watching>
   0xc011dba8 <+352>:	cmp	r0, #0
   0xc011dbac <+356>:	bne	0xc011db88 <find_get_entry+320>
   0xc011dbb0 <+360>:	mov	r3, #1
   0xc011dbb4 <+364>:	ldr	r0, [pc, #208]	; 0xc011dc8c <find_get_entry+580>
   0xc011dbb8 <+368>:	ldr	r1, [pc, #208]	; 0xc011dc90 <find_get_entry+584>
   0xc011dbbc <+372>:	ldr	r2, [pc, #208]	; 0xc011dc94 <find_get_entry+588>
   0xc011dbc0 <+376>:	strb	r3, [r5, #3]
   0xc011dbc4 <+380>:	bl	0xc00920cc <lockdep_rcu_suspicious>
   0xc011dbc8 <+384>:	b	0xc011db88 <find_get_entry+320>
   0xc011dbcc <+388>:	bl	0xc00a7b50 <debug_lockdep_rcu_enabled>
   0xc011dbd0 <+392>:	cmp	r0, #0
   0xc011dbd4 <+396>:	beq	0xc011dae8 <find_get_entry+160>
   0xc011dbd8 <+400>:	bl	0xc00aadc4 <rcu_is_watching>
   0xc011dbdc <+404>:	cmp	r0, #0
   0xc011dbe0 <+408>:	bne	0xc011dc2c <find_get_entry+484>
   0xc011dbe4 <+412>:	ldr	r0, [pc, #172]	; 0xc011dc98 <find_get_entry+592>
   0xc011dbe8 <+416>:	mov	r1, #196	; 0xc4
   0xc011dbec <+420>:	ldr	r2, [pc, #168]	; 0xc011dc9c <find_get_entry+596>
   0xc011dbf0 <+424>:	strb	r5, [r8, #2]
   0xc011dbf4 <+428>:	bl	0xc00920cc <lockdep_rcu_suspicious>
   0xc011dbf8 <+432>:	b	0xc011dae8 <find_get_entry+160>
   0xc011dbfc <+436>:	bl	0xc00aadc4 <rcu_is_watching>
   0xc011dc00 <+440>:	cmp	r0, #0
   0xc011dc04 <+444>:	bne	0xc011daac <find_get_entry+100>
   0xc011dc08 <+448>:	mov	r3, #1
   0xc011dc0c <+452>:	ldr	r0, [pc, #120]	; 0xc011dc8c <find_get_entry+580>
   0xc011dc10 <+456>:	mov	r1, #844	; 0x34c
   0xc011dc14 <+460>:	ldr	r2, [pc, #132]	; 0xc011dca0 <find_get_entry+600>
   0xc011dc18 <+464>:	strb	r3, [r4, #1]
   0xc011dc1c <+468>:	bl	0xc00920cc <lockdep_rcu_suspicious>
   0xc011dc20 <+472>:	b	0xc011daac <find_get_entry+100>
   0xc011dc24 <+476>:	mov	r4, #0
   0xc011dc28 <+480>:	b	0xc011db6c <find_get_entry+292>
   0xc011dc2c <+484>:	bl	0xc00ac38c <rcu_lockdep_current_cpu_online>
   0xc011dc30 <+488>:	cmp	r0, #0
   0xc011dc34 <+492>:	beq	0xc011dbe4 <find_get_entry+412>
   0xc011dc38 <+496>:	ldr	r0, [pc, #60]	; 0xc011dc7c <find_get_entry+564>
   0xc011dc3c <+500>:	bl	0xc0091264 <lock_is_held>
   0xc011dc40 <+504>:	cmp	r0, #0
   0xc011dc44 <+508>:	beq	0xc011dbe4 <find_get_entry+412>
   0xc011dc48 <+512>:	b	0xc011dae8 <find_get_entry+160>
   0xc011dc4c <+516>:	tst	r4, #1
   0xc011dc50 <+520>:	beq	0xc011db6c <find_get_entry+292>
   0xc011dc54 <+524>:	b	0xc011dab8 <find_get_entry+112>
   0xc011dc58 <+528>:	mov	r0, r4
   0xc011dc5c <+532>:	ldr	r1, [pc, #64]	; 0xc011dca4 <find_get_entry+604>
   0xc011dc60 <+536>:	bl	0xc01254d4 <dump_page>
   0xc011dc64 <+540>:			; <UNDEFINED> instruction: 0xe7f001f2
   0xc011dc68 <+544>:			; <UNDEFINED> instruction: 0xe7f001f2
   0xc011dc6c <+548>:	mov	r0, r4
   0xc011dc70 <+552>:	bl	0xc012db6c <put_page>
   0xc011dc74 <+556>:	b	0xc011dab8 <find_get_entry+112>
   0xc011dc78 <+560>:	andsgt	sp, r1, r8, asr #20
   0xc011dc7c <+564>:	adcgt	r2, r11, r8, lsl r2
   0xc011dc80 <+568>:	ldrhtgt	r0, [r0], r1
   0xc011dc84 <+572>:	andseq	pc, pc, r0, lsl #30
   0xc011dc88 <+576>:	andsgt	sp, r1, r8, lsl #23
   0xc011dc8c <+580>:	addgt	sp, r5, r8, lsl #5
   0xc011dc90 <+584>:	andeq	r0, r0, sp, ror r3
   0xc011dc94 <+588>:	ldrdgt	sp, [r5], r0
   0xc011dc98 <+592>:	addgt	sp, r7, r8, asr #7
   0xc011dc9c <+596>:	addgt	lr, r6, r8, lsl #17
   0xc011dca0 <+600>:	addgt	sp, r5, r4, lsr #5
   0xc011dca4 <+604>:	addgt	sp, r7, r4, ror #7
End of assembler dump.

> I'm thinking it's not the slot pointer itself that's bad, because
> __radix_tree_lookup() dereferences that to test if it's populated
> before returning it, and slot life-time is guaranteed by RCU.
>=20
> That would only leave garbage in the slot itself, crashing during
> page_cache_get_speculative().
>=20
> I'll keep staring at this change, but nothing stands out to me yet.

alright, it's pretty deterministic however. Always on the same test, no
matter which USB controller, no matter if backing store is RAM or MMC.

Those two undefined instructions on the disassembly caught my attention,
perhaps I'm facing a GCC bug ?

--=20
balbi

--+JUInw4efm7IfTNU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNrdQAAoJEIaOsuA1yqREz2gQAI1zviv/BnbNNb+ShBVaCRJd
jpFR55vvXJO3vHlhphhvqxTlX8SwVwIbxDuPJ1pWUg86gLJAMJQWL4pPIxp0fWzr
m9+q/1xPtuZUlzC44t1eqRlSfphSO/DAfyiP4Jh2fWgWeDmPHS1JYQLV05DtNBA7
8LOyf8iIfenamg/LMVNG+3Qh1z7ezoEBN2KXVlcwcFsQ32dj2d+Tpt2MhC1dPNqb
L24mGqJkJbuK+qAJHfUwBvYsihwvEBV2pIz8X5uicEEqK8ZRIV+8Yfm6NpJVnzzv
LByBD+DWbjy/jOzOmqtQwgVrxf+ARsD/eTXbQUci37TeAcegUMJ+ERdT3ZECDEZR
S/s1Ih2rFLjF/JpBl6YJe7fY++w33rl+vCYcZqV3MAAlViajUaat370rQ0ycz29C
ak8XC+uImt6R0Z0PJaUX3K7OnjE0Y5xG800xAqQvOgT5eCE7iae16ZKhyA4tj4GL
ArK6FviabDijxDR9ec8tCQLCBxXs8autCT0h75EvhUFsi0ifLxoAB9QuPFykf50V
Nj5YzrGQMgsgbGeDKZxTTGfUsb2cuxgXVigQRAdtuE7rNhv6MVmDgM40jKpuec/Y
KUgZWR8IAhN6FcsHgn4Aclt+AMisvcwWxSQ8daRNY53oRd/GgoKExXzYaTpmu7WN
+Q091d1Lv9EdD5QxCQDK
=cEdk
-----END PGP SIGNATURE-----

--+JUInw4efm7IfTNU--

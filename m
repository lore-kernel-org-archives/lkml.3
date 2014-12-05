Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbaLEBBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:01:30 -0500
Received: from smtprelay0122.hostedemail.com ([216.40.44.122]:36850 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932820AbaLEBB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:01:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1543:1593:1594:1605:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:4250:4321:5007:6117:6119:6261:6691:6742:7514:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12346:12438:12517:12519:12555:12740:13146:13230:13972:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wing41_2996f9c820c39
X-Filterd-Recvd-Size: 5264
Message-ID: <1417741284.2721.26.camel@perches.com>
Subject: [PATCH] x86: bpf_jit_comp: Remove inline from static function
 definitions
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 04 Dec 2014 17:01:24 -0800
In-Reply-To: <1417740382.22424.40.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CAADnVQKtYkKtsd9rUFm2yfMoh7F_SRFPVP8hpvSY00KpmB-NNg@mail.gmail.com>
	 <1417734048.2721.22.camel@perches.com>
	 <1417734891.22424.2.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAADnVQ+3jiYOYReRLPUsFeG1p66ezo-TXBLX3BGQQh7V8QX0tQ@mail.gmail.com>
	 <1417740382.22424.40.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the compiler decide instead.

No change in object size x86-64 -O2 no profiling

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
---
On Thu, 2014-12-04 at 16:46 -0800, Eric Dumazet wrote:
> On Thu, 2014-12-04 at 15:31 -0800, Alexei Starovoitov wrote:
> 
> > well, it is a trivial function even from compiler point of view.
> > Dropping inline keyword doesn't help. gcc still inlines them.
> > Changing all 3 functions to _noinline_ doesn't help either.
> > So I think this patch is actually quite helpful to reduce code size.
> 
> Well, again this might depend on CONFIG_CC_OPTIMIZE_FOR_SIZE

-Os has a different size delta, but it's still
smaller using this new function.

> I guess people trying to get very small kernels are using this option.
> 
> My point was : If we care about code size, we should also remove these
> inline keywords at the same time, to increase SNR of netdev/lkml lists.

Because there's no object change here, inline removals
would probably be a good thing for this file.

 arch/x86/net/bpf_jit_comp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 09e2cea..626e013 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -24,7 +24,7 @@ extern u8 sk_load_byte_positive_offset[];
 extern u8 sk_load_word_negative_offset[], sk_load_half_negative_offset[];
 extern u8 sk_load_byte_negative_offset[];
 
-static inline u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
+static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
 {
 	if (len == 1)
 		*ptr = bytes;
@@ -52,12 +52,12 @@ static inline u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
 #define EMIT4_off32(b1, b2, b3, b4, off) \
 	do {EMIT4(b1, b2, b3, b4); EMIT(off, 4); } while (0)
 
-static inline bool is_imm8(int value)
+static bool is_imm8(int value)
 {
 	return value <= 127 && value >= -128;
 }
 
-static inline bool is_simm32(s64 value)
+static bool is_simm32(s64 value)
 {
 	return value == (s64) (s32) value;
 }
@@ -94,7 +94,7 @@ static int bpf_size_to_x86_bytes(int bpf_size)
 #define X86_JGE 0x7D
 #define X86_JG  0x7F
 
-static inline void bpf_flush_icache(void *start, void *end)
+static void bpf_flush_icache(void *start, void *end)
 {
 	mm_segment_t old_fs = get_fs();
 
@@ -133,7 +133,7 @@ static const int reg2hex[] = {
  * which need extra byte of encoding.
  * rax,rcx,...,rbp have simpler encoding
  */
-static inline bool is_ereg(u32 reg)
+static bool is_ereg(u32 reg)
 {
 	return (1 << reg) & (BIT(BPF_REG_5) |
 			     BIT(AUX_REG) |
@@ -143,14 +143,14 @@ static inline bool is_ereg(u32 reg)
 }
 
 /* add modifiers if 'reg' maps to x64 registers r8..r15 */
-static inline u8 add_1mod(u8 byte, u32 reg)
+static u8 add_1mod(u8 byte, u32 reg)
 {
 	if (is_ereg(reg))
 		byte |= 1;
 	return byte;
 }
 
-static inline u8 add_2mod(u8 byte, u32 r1, u32 r2)
+static u8 add_2mod(u8 byte, u32 r1, u32 r2)
 {
 	if (is_ereg(r1))
 		byte |= 1;
@@ -160,13 +160,13 @@ static inline u8 add_2mod(u8 byte, u32 r1, u32 r2)
 }
 
 /* encode 'dst_reg' register into x64 opcode 'byte' */
-static inline u8 add_1reg(u8 byte, u32 dst_reg)
+static u8 add_1reg(u8 byte, u32 dst_reg)
 {
 	return byte + reg2hex[dst_reg];
 }
 
 /* encode 'dst_reg' and 'src_reg' registers into x64 opcode 'byte' */
-static inline u8 add_2reg(u8 byte, u32 dst_reg, u32 src_reg)
+static u8 add_2reg(u8 byte, u32 dst_reg, u32 src_reg)
 {
 	return byte + reg2hex[dst_reg] + (reg2hex[src_reg] << 3);
 }



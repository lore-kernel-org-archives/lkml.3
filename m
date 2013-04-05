Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161867Ab3DEIFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:05:11 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:46619 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161089Ab3DEIFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:05:07 -0400
Message-ID: <515E859E.7080206@synopsys.com>
Date: Fri, 5 Apr 2013 13:34:46 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Oskar Andero <oskar.andero@sonymobile.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <davem@davemloft.net>,
        <anil.s.keshavamurthy@intel.com>, <ananth@in.ibm.com>,
        <radovan.lekanovic@sonymobile.com>, <bjorn.davidsson@sonymobile.com>
Subject: Re: [PATCH v2 2/4] kprobes: split blacklist into common and arch
References: <1365079889-21525-1-git-send-email-oskar.andero@sonymobile.com> <1365079889-21525-3-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1365079889-21525-3-git-send-email-oskar.andero@sonymobile.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 06:21 PM, Oskar Andero wrote:
> Some blackpoints are only valid for specific architectures. To let each
> architecture specify its own blackpoints the list has been split in two
> lists: common and arch. The common list is kept in kernel/kprobes.c and
> the arch list is kept in the arch/ directory.
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: linux-arch@vger.kernel.org
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  arch/arc/kernel/kprobes.c      |  3 ++
>  arch/arm/kernel/kprobes.c      |  2 +
>  arch/avr32/kernel/kprobes.c    |  3 ++
>  arch/ia64/kernel/kprobes.c     |  3 ++
>  arch/mips/kernel/kprobes.c     |  3 ++
>  arch/mn10300/kernel/kprobes.c  |  2 +
>  arch/powerpc/kernel/kprobes.c  |  3 ++
>  arch/s390/kernel/kprobes.c     |  3 ++
>  arch/sh/kernel/kprobes.c       |  3 ++
>  arch/sparc/kernel/kprobes.c    |  3 ++
>  arch/x86/kernel/kprobes/core.c |  3 ++
>  kernel/kprobes.c               | 85 +++++++++++++++++++++++++++---------------
>  12 files changed, 86 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arc/kernel/kprobes.c b/arch/arc/kernel/kprobes.c
> index 3bfeacb..894eee6 100644
> --- a/arch/arc/kernel/kprobes.c
> +++ b/arch/arc/kernel/kprobes.c
> @@ -24,6 +24,9 @@
>  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
>  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
> +
>  int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  {
>  	/* Attempt to probe at unaligned address */
> diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
> index 170e9f3..772d9ec 100644
> --- a/arch/arm/kernel/kprobes.c
> +++ b/arch/arm/kernel/kprobes.c
> @@ -46,6 +46,8 @@
>  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
>  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
>  
>  int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  {
> diff --git a/arch/avr32/kernel/kprobes.c b/arch/avr32/kernel/kprobes.c
> index f820e9f..3b02c1e 100644
> --- a/arch/avr32/kernel/kprobes.c
> +++ b/arch/avr32/kernel/kprobes.c
> @@ -24,6 +24,9 @@ static struct pt_regs jprobe_saved_regs;
>  
>  struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
> +
>  int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  {
>  	int ret = 0;
> diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
> index f8280a7..239f2fd 100644
> --- a/arch/ia64/kernel/kprobes.c
> +++ b/arch/ia64/kernel/kprobes.c
> @@ -42,6 +42,9 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
>  struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
> +
>  enum instruction_type {A, I, M, F, B, L, X, u};
>  static enum instruction_type bundle_encoding[32][3] = {
>    { M, I, I },				/* 00 */
> diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
> index 12bc4eb..de6a1aa 100644
> --- a/arch/mips/kernel/kprobes.c
> +++ b/arch/mips/kernel/kprobes.c
> @@ -53,6 +53,9 @@ static const union mips_instruction breakpoint2_insn = {
>  DEFINE_PER_CPU(struct kprobe *, current_kprobe);
>  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
> +
>  static int __kprobes insn_has_delayslot(union mips_instruction insn)
>  {
>  	switch (insn.i_format.opcode) {
> diff --git a/arch/mn10300/kernel/kprobes.c b/arch/mn10300/kernel/kprobes.c
> index 0311a7f..ed57094 100644
> --- a/arch/mn10300/kernel/kprobes.c
> +++ b/arch/mn10300/kernel/kprobes.c
> @@ -41,6 +41,8 @@ static unsigned long cur_kprobe_bp_addr;
>  
>  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
>  
>  /* singlestep flag bits */
>  #define SINGLESTEP_BRANCH 1
> diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
> index 11f5b03..b18ba45 100644
> --- a/arch/powerpc/kernel/kprobes.c
> +++ b/arch/powerpc/kernel/kprobes.c
> @@ -47,6 +47,9 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
>  struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
> +
>  int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  {
>  	int ret = 0;
> diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
> index 3388b2b..2077bb0 100644
> --- a/arch/s390/kernel/kprobes.c
> +++ b/arch/s390/kernel/kprobes.c
> @@ -37,6 +37,9 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
>  struct kretprobe_blackpoint kretprobe_blacklist[] = { };
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
> +
>  static int __kprobes is_prohibited_opcode(kprobe_opcode_t *insn)
>  {
>  	switch (insn[0] >> 8) {
> diff --git a/arch/sh/kernel/kprobes.c b/arch/sh/kernel/kprobes.c
> index 42b46e6..8acfb02 100644
> --- a/arch/sh/kernel/kprobes.c
> +++ b/arch/sh/kernel/kprobes.c
> @@ -24,6 +24,9 @@ static DEFINE_PER_CPU(struct kprobe, saved_current_opcode);
>  static DEFINE_PER_CPU(struct kprobe, saved_next_opcode);
>  static DEFINE_PER_CPU(struct kprobe, saved_next_opcode2);
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
> +
>  #define OPCODE_JMP(x)	(((x) & 0xF0FF) == 0x402b)
>  #define OPCODE_JSR(x)	(((x) & 0xF0FF) == 0x400b)
>  #define OPCODE_BRA(x)	(((x) & 0xF000) == 0xa000)
> diff --git a/arch/sparc/kernel/kprobes.c b/arch/sparc/kernel/kprobes.c
> index e722121..627e35c 100644
> --- a/arch/sparc/kernel/kprobes.c
> +++ b/arch/sparc/kernel/kprobes.c
> @@ -45,6 +45,9 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
>  struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
> +
>  int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  {
>  	if ((unsigned long) p->addr & 0x3UL)
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> index 7bfe318..4aa71a5 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -65,6 +65,9 @@ void jprobe_return_end(void);
>  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
>  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
> +const char * const arch_kprobes_blacksyms[] = {};
> +const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
> +
>  #define stack_addr(regs) ((unsigned long *)kernel_stack_pointer(regs))
>  
>  #define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 0a270e5..7654278 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -68,7 +68,6 @@
>  #endif
>  
>  static int kprobes_initialized;
> -static int kprobe_blacklist_initialized;
>  static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
>  static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
>  
> @@ -94,31 +93,60 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
>   *
>   * For such cases, we now have a blacklist
>   */
> -static struct kprobe_blackpoint kprobe_blacklist[] = {
> -	{"preempt_schedule",},
> -	{"native_get_debugreg",},
> -	{"irq_entries_start",},
> -	{"common_interrupt",},
> -	{"mcount",},	/* mcount can be called from everywhere */
> -	{NULL}    /* Terminator */
> +static const char * const common_kprobes_blacksyms[] = {
> +	"preempt_schedule",
> +	"native_get_debugreg",
> +	"irq_entries_start",
> +	"common_interrupt",
> +	"mcount",       /* mcount can be called from everywhere */
>  };
> +static const size_t common_kprobes_blacksyms_size =
> +			ARRAY_SIZE(common_kprobes_blacksyms);
> +
> +extern const char * const arch_kprobes_blacksyms[];
> +extern const size_t arch_kprobes_blacksyms_size;

Instead of this, if you define arch_kprobes_blacksyms{,_size} as weak symbols
here, you don't need to patch all the arches for dummy empty entries.
Any arch which cares for a blacklist can easily override the weak def by defining
it's own copy. A lot of core kernel code - where arch variant is NOT typically use
dis written this way !

Thx,
-Vineet

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3JIOr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:47:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41962 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab3JIOrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:47:17 -0400
Date: Wed, 9 Oct 2013 16:46:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009144656.GV26785@twins.programming.kicks-ass.net>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008143400.GA14721@redhat.com>
 <20131009080459.GA2298@localhost>
 <20131009124310.GA11769@redhat.com>
 <20131009140734.GH3081@twins.programming.kicks-ass.net>
 <20131009143359.GU26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20131009143359.GU26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2013 at 04:33:59PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 09, 2013 at 04:07:34PM +0200, Peter Zijlstra wrote:
> > Once I force a x86_64 build using the 'same' config it goes away and
> > generates 'sensible' code again (although I don't see why L9 isn't
> > merged with L2):
>=20
> i386-SMP also generates correct code afaict; a tad stupid but not wrong.
>=20
> If I remove ftrace from the .config its still broken..
> If I also remove the likely/unlikely tracer its still broken and lots
> smaller:

OK, its -march=3Dwinchip2 that's buggered.

Find attached task_work.i and try:

gcc -nostdinc -I /usr/src/linux-2.6/arch/x86/include -I arch/x86/include/ge=
nerated -I /usr/src/linux-2.6/include -I include -I /usr/src/linux-2.6/arch=
/x86/include/uapi -I arch/x86/include/generated/uapi -I /usr/src/linux-2.6/=
include/uapi -I include/generated/uapi -I /usr/src/linux-2.6/kernel -I kern=
el  -D __KERNEL__ -D CONFIG_AS_CFI=3D1 -D CONFIG_AS_CFI_SIGNAL_FRAME=3D1 -D=
 CONFIG_AS_CFI_SECTIONS=3D1 -D CONFIG_AS_AVX=3D1 -D CONFIG_AS_AVX2=3D1 -D C=
C_HAVE_ASM_GOTO -D "KBUILD_STR(s)=3D#s" -D "KBUILD_BASENAME=3DKBUILD_STR(ta=
sk_work)" -D KBUILD_MODNAME=3D"KBUILD_STR(task_work)" -isystem /usr/lib/gcc=
/x86_64-linux-gnu/4.8/include -include /usr/src/linux-2.6/include/linux/kco=
nfig.h -m32 -msoft-float -mregparm=3D3 -mpreferred-stack-boundary=3D2 -marc=
h=3Di686 -mtune=3Dgeneric -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -=
O2 -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -Werror=3Dimplicit-func=
tion-declaration -Wno-format-security -Wno-sign-compare -Wframe-larger-than=
=3D2048 -Wno-unused-but-set-variable -Wdeclaration-after-statement -Wno-poi=
nter-sign -fno-strict-aliasing -fno-common -fno-delete-null-pointer-checks =
-freg-struct-return -fno-pic -ffreestanding -fno-asynchronous-unwind-tables=
 -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -=
fno-strict-overflow -fconserve-stack -fverbose-asm -S -o - task_work.i

and

gcc -nostdinc -I /usr/src/linux-2.6/arch/x86/include -I arch/x86/include/ge=
nerated -I /usr/src/linux-2.6/include -I include -I /usr/src/linux-2.6/arch=
/x86/include/uapi -I arch/x86/include/generated/uapi -I /usr/src/linux-2.6/=
include/uapi -I include/generated/uapi -I /usr/src/linux-2.6/kernel -I kern=
el  -D __KERNEL__ -D CONFIG_AS_CFI=3D1 -D CONFIG_AS_CFI_SIGNAL_FRAME=3D1 -D=
 CONFIG_AS_CFI_SECTIONS=3D1 -D CONFIG_AS_AVX=3D1 -D CONFIG_AS_AVX2=3D1 -D C=
C_HAVE_ASM_GOTO -D "KBUILD_STR(s)=3D#s" -D "KBUILD_BASENAME=3DKBUILD_STR(ta=
sk_work)" -D KBUILD_MODNAME=3D"KBUILD_STR(task_work)" -isystem /usr/lib/gcc=
/x86_64-linux-gnu/4.8/include -include /usr/src/linux-2.6/include/linux/kco=
nfig.h -m32 -msoft-float -mregparm=3D3 -mpreferred-stack-boundary=3D2 -marc=
h=3Dwinchip2 -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -O2 -Wall -Wun=
def -Wstrict-prototypes -Wno-trigraphs -Werror=3Dimplicit-function-declarat=
ion -Wno-format-security -Wno-sign-compare -Wframe-larger-than=3D2048 -Wno-=
unused-but-set-variable -Wdeclaration-after-statement -Wno-pointer-sign -fn=
o-strict-aliasing -fno-common -fno-delete-null-pointer-checks -freg-struct-=
return -fno-pic -ffreestanding -fno-asynchronous-unwind-tables -fno-stack-p=
rotector -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-strict-ov=
erflow -fconserve-stack -fverbose-asm -S -o - task_work.i | less




--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="task_work.i"
Content-Transfer-Encoding: quoted-printable

# 1 "/usr/src/linux-2.6/kernel/task_work.c"
# 1 "<command-line>"
# 1 "/usr/src/linux-2.6/include/linux/kconfig.h" 1



# 1 "include/generated/autoconf.h" 1
# 5 "/usr/src/linux-2.6/include/linux/kconfig.h" 2
# 1 "<command-line>" 2
# 1 "/usr/src/linux-2.6/kernel/task_work.c"
# 1 "/usr/src/linux-2.6/include/linux/spinlock.h" 1
# 49 "/usr/src/linux-2.6/include/linux/spinlock.h"
# 1 "/usr/src/linux-2.6/include/linux/typecheck.h" 1
# 50 "/usr/src/linux-2.6/include/linux/spinlock.h" 2
# 1 "/usr/src/linux-2.6/include/linux/preempt.h" 1
# 9 "/usr/src/linux-2.6/include/linux/preempt.h"
# 1 "/usr/src/linux-2.6/include/linux/linkage.h" 1



# 1 "/usr/src/linux-2.6/include/linux/compiler.h" 1
# 54 "/usr/src/linux-2.6/include/linux/compiler.h"
# 1 "/usr/src/linux-2.6/include/linux/compiler-gcc.h" 1
# 103 "/usr/src/linux-2.6/include/linux/compiler-gcc.h"
# 1 "/usr/src/linux-2.6/include/linux/compiler-gcc4.h" 1
# 104 "/usr/src/linux-2.6/include/linux/compiler-gcc.h" 2
# 55 "/usr/src/linux-2.6/include/linux/compiler.h" 2
# 72 "/usr/src/linux-2.6/include/linux/compiler.h"
struct ftrace_branch_data {
 const char *func;
 const char *file;
 unsigned line;
 union {
  struct {
   unsigned long correct;
   unsigned long incorrect;
  };
  struct {
   unsigned long miss;
   unsigned long hit;
  };
  unsigned long miss_hit[2];
 };
};
# 5 "/usr/src/linux-2.6/include/linux/linkage.h" 2
# 1 "/usr/src/linux-2.6/include/linux/stringify.h" 1
# 6 "/usr/src/linux-2.6/include/linux/linkage.h" 2
# 1 "/usr/src/linux-2.6/include/linux/export.h" 1
# 26 "/usr/src/linux-2.6/include/linux/export.h"
struct kernel_symbol
{
 unsigned long value;
 const char *name;
};
# 7 "/usr/src/linux-2.6/include/linux/linkage.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/linkage.h" 1
# 8 "/usr/src/linux-2.6/include/linux/linkage.h" 2
# 10 "/usr/src/linux-2.6/include/linux/preempt.h" 2
# 1 "/usr/src/linux-2.6/include/linux/list.h" 1



# 1 "/usr/src/linux-2.6/include/linux/types.h" 1




# 1 "/usr/src/linux-2.6/include/uapi/linux/types.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/types.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/types.h" 1






# 1 "/usr/src/linux-2.6/include/asm-generic/int-ll64.h" 1
# 10 "/usr/src/linux-2.6/include/asm-generic/int-ll64.h"
# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/int-ll64.h" 1
# 11 "/usr/src/linux-2.6/include/uapi/asm-generic/int-ll64.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/bitsperlong.h" 1
# 10 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/bitsperlong.h"
# 1 "/usr/src/linux-2.6/include/asm-generic/bitsperlong.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/bitsperlong.h" 1
# 5 "/usr/src/linux-2.6/include/asm-generic/bitsperlong.h" 2
# 11 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/bitsperlong.h" 2
# 12 "/usr/src/linux-2.6/include/uapi/asm-generic/int-ll64.h" 2







typedef __signed__ char __s8;
typedef unsigned char __u8;

typedef __signed__ short __s16;
typedef unsigned short __u16;

typedef __signed__ int __s32;
typedef unsigned int __u32;


__extension__ typedef __signed__ long long __s64;
__extension__ typedef unsigned long long __u64;
# 11 "/usr/src/linux-2.6/include/asm-generic/int-ll64.h" 2




typedef signed char s8;
typedef unsigned char u8;

typedef signed short s16;
typedef unsigned short u16;

typedef signed int s32;
typedef unsigned int u32;

typedef signed long long s64;
typedef unsigned long long u64;
# 8 "/usr/src/linux-2.6/include/uapi/asm-generic/types.h" 2
# 5 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/types.h" 2
# 5 "/usr/src/linux-2.6/include/uapi/linux/types.h" 2
# 13 "/usr/src/linux-2.6/include/uapi/linux/types.h"
# 1 "/usr/src/linux-2.6/include/uapi/linux/posix_types.h" 1



# 1 "/usr/src/linux-2.6/include/linux/stddef.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/stddef.h" 1
# 5 "/usr/src/linux-2.6/include/linux/stddef.h" 2





enum {
 false =3D 0,
 true =3D 1
};
# 5 "/usr/src/linux-2.6/include/uapi/linux/posix_types.h" 2
# 24 "/usr/src/linux-2.6/include/uapi/linux/posix_types.h"
typedef struct {
 unsigned long fds_bits[1024 / (8 * sizeof(long))];
} __kernel_fd_set;


typedef void (*__kernel_sighandler_t)(int);


typedef int __kernel_key_t;
typedef int __kernel_mqd_t;

# 1 "/usr/src/linux-2.6/arch/x86/include/asm/posix_types.h" 1

# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/posix_types_32.h" 1
# 10 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/posix_types_32.h"
typedef unsigned short __kernel_mode_t;


typedef unsigned short __kernel_ipc_pid_t;


typedef unsigned short __kernel_uid_t;
typedef unsigned short __kernel_gid_t;


typedef unsigned short __kernel_old_dev_t;


# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/posix_types.h" 1
# 14 "/usr/src/linux-2.6/include/uapi/asm-generic/posix_types.h"
typedef long __kernel_long_t;
typedef unsigned long __kernel_ulong_t;



typedef __kernel_ulong_t __kernel_ino_t;







typedef int __kernel_pid_t;
# 40 "/usr/src/linux-2.6/include/uapi/asm-generic/posix_types.h"
typedef __kernel_long_t __kernel_suseconds_t;



typedef int __kernel_daddr_t;



typedef unsigned int __kernel_uid32_t;
typedef unsigned int __kernel_gid32_t;



typedef __kernel_uid_t __kernel_old_uid_t;
typedef __kernel_gid_t __kernel_old_gid_t;
# 67 "/usr/src/linux-2.6/include/uapi/asm-generic/posix_types.h"
typedef unsigned int __kernel_size_t;
typedef int __kernel_ssize_t;
typedef int __kernel_ptrdiff_t;
# 78 "/usr/src/linux-2.6/include/uapi/asm-generic/posix_types.h"
typedef struct {
 int val[2];
} __kernel_fsid_t;





typedef __kernel_long_t __kernel_off_t;
typedef long long __kernel_loff_t;
typedef __kernel_long_t __kernel_time_t;
typedef __kernel_long_t __kernel_clock_t;
typedef int __kernel_timer_t;
typedef int __kernel_clockid_t;
typedef char * __kernel_caddr_t;
typedef unsigned short __kernel_uid16_t;
typedef unsigned short __kernel_gid16_t;
# 24 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/posix_types_32.h" 2
# 3 "/usr/src/linux-2.6/arch/x86/include/asm/posix_types.h" 2
# 36 "/usr/src/linux-2.6/include/uapi/linux/posix_types.h" 2
# 14 "/usr/src/linux-2.6/include/uapi/linux/types.h" 2
# 32 "/usr/src/linux-2.6/include/uapi/linux/types.h"
typedef __u16 __le16;
typedef __u16 __be16;
typedef __u32 __le32;
typedef __u32 __be32;
typedef __u64 __le64;
typedef __u64 __be64;

typedef __u16 __sum16;
typedef __u32 __wsum;
# 6 "/usr/src/linux-2.6/include/linux/types.h" 2






typedef __u32 __kernel_dev_t;

typedef __kernel_fd_set fd_set;
typedef __kernel_dev_t dev_t;
typedef __kernel_ino_t ino_t;
typedef __kernel_mode_t mode_t;
typedef unsigned short umode_t;
typedef __u32 nlink_t;
typedef __kernel_off_t off_t;
typedef __kernel_pid_t pid_t;
typedef __kernel_daddr_t daddr_t;
typedef __kernel_key_t key_t;
typedef __kernel_suseconds_t suseconds_t;
typedef __kernel_timer_t timer_t;
typedef __kernel_clockid_t clockid_t;
typedef __kernel_mqd_t mqd_t;

typedef _Bool bool;

typedef __kernel_uid32_t uid_t;
typedef __kernel_gid32_t gid_t;
typedef __kernel_uid16_t uid16_t;
typedef __kernel_gid16_t gid16_t;

typedef unsigned long uintptr_t;



typedef __kernel_old_uid_t old_uid_t;
typedef __kernel_old_gid_t old_gid_t;



typedef __kernel_loff_t loff_t;
# 54 "/usr/src/linux-2.6/include/linux/types.h"
typedef __kernel_size_t size_t;




typedef __kernel_ssize_t ssize_t;




typedef __kernel_ptrdiff_t ptrdiff_t;




typedef __kernel_time_t time_t;




typedef __kernel_clock_t clock_t;




typedef __kernel_caddr_t caddr_t;



typedef unsigned char u_char;
typedef unsigned short u_short;
typedef unsigned int u_int;
typedef unsigned long u_long;


typedef unsigned char unchar;
typedef unsigned short ushort;
typedef unsigned int uint;
typedef unsigned long ulong;




typedef __u8 u_int8_t;
typedef __s8 int8_t;
typedef __u16 u_int16_t;
typedef __s16 int16_t;
typedef __u32 u_int32_t;
typedef __s32 int32_t;



typedef __u8 uint8_t;
typedef __u16 uint16_t;
typedef __u32 uint32_t;


typedef __u64 uint64_t;
typedef __u64 u_int64_t;
typedef __s64 int64_t;
# 130 "/usr/src/linux-2.6/include/linux/types.h"
typedef u64 sector_t;
typedef u64 blkcnt_t;
# 148 "/usr/src/linux-2.6/include/linux/types.h"
typedef u32 dma_addr_t;
# 157 "/usr/src/linux-2.6/include/linux/types.h"
typedef unsigned gfp_t;
typedef unsigned fmode_t;
typedef unsigned oom_flags_t;




typedef u32 phys_addr_t;


typedef phys_addr_t resource_size_t;





typedef unsigned long irq_hw_number_t;

typedef struct {
 int counter;
} atomic_t;







struct list_head {
 struct list_head *next, *prev;
};

struct hlist_head {
 struct hlist_node *first;
};

struct hlist_node {
 struct hlist_node *next, **pprev;
};

struct ustat {
 __kernel_daddr_t f_tfree;
 __kernel_ino_t f_tinode;
 char f_fname[6];
 char f_fpack[6];
};






struct callback_head {
 struct callback_head *next;
 void (*func)(struct callback_head *head);
};
# 5 "/usr/src/linux-2.6/include/linux/list.h" 2

# 1 "/usr/src/linux-2.6/include/linux/poison.h" 1
# 7 "/usr/src/linux-2.6/include/linux/list.h" 2
# 1 "/usr/src/linux-2.6/include/uapi/linux/const.h" 1
# 8 "/usr/src/linux-2.6/include/linux/list.h" 2
# 24 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void INIT_LIST_HEAD(s=
truct list_head *list)
{
 list->next =3D list;
 list->prev =3D list;
}
# 37 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void __list_add(struc=
t list_head *new,
         struct list_head *prev,
         struct list_head *next)
{
 next->prev =3D new;
 new->next =3D next;
 new->prev =3D prev;
 prev->next =3D new;
}
# 60 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void list_add(struct =
list_head *new, struct list_head *head)
{
 __list_add(new, head, head->next);
}
# 74 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void list_add_tail(st=
ruct list_head *new, struct list_head *head)
{
 __list_add(new, head->prev, head);
}
# 86 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void __list_del(struc=
t list_head * prev, struct list_head * next)
{
 next->prev =3D prev;
 prev->next =3D next;
}
# 99 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void __list_del_entry=
(struct list_head *entry)
{
 __list_del(entry->prev, entry->next);
}

static inline __attribute__((no_instrument_function)) void list_del(struct =
list_head *entry)
{
 __list_del(entry->prev, entry->next);
 entry->next =3D ((void *) 0x00100100 + (0x0UL));
 entry->prev =3D ((void *) 0x00200200 + (0x0UL));
}
# 122 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void list_replace(str=
uct list_head *old,
    struct list_head *new)
{
 new->next =3D old->next;
 new->next->prev =3D new;
 new->prev =3D old->prev;
 new->prev->next =3D new;
}

static inline __attribute__((no_instrument_function)) void list_replace_ini=
t(struct list_head *old,
     struct list_head *new)
{
 list_replace(old, new);
 INIT_LIST_HEAD(old);
}





static inline __attribute__((no_instrument_function)) void list_del_init(st=
ruct list_head *entry)
{
 __list_del_entry(entry);
 INIT_LIST_HEAD(entry);
}






static inline __attribute__((no_instrument_function)) void list_move(struct=
 list_head *list, struct list_head *head)
{
 __list_del_entry(list);
 list_add(list, head);
}






static inline __attribute__((no_instrument_function)) void list_move_tail(s=
truct list_head *list,
      struct list_head *head)
{
 __list_del_entry(list);
 list_add_tail(list, head);
}






static inline __attribute__((no_instrument_function)) int list_is_last(cons=
t struct list_head *list,
    const struct list_head *head)
{
 return list->next =3D=3D head;
}





static inline __attribute__((no_instrument_function)) int list_empty(const =
struct list_head *head)
{
 return head->next =3D=3D head;
}
# 204 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) int list_empty_carefu=
l(const struct list_head *head)
{
 struct list_head *next =3D head->next;
 return (next =3D=3D head) && (next =3D=3D head->prev);
}





static inline __attribute__((no_instrument_function)) void list_rotate_left=
(struct list_head *head)
{
 struct list_head *first;

 if (!list_empty(head)) {
  first =3D head->next;
  list_move_tail(first, head);
 }
}





static inline __attribute__((no_instrument_function)) int list_is_singular(=
const struct list_head *head)
{
 return !list_empty(head) && (head->next =3D=3D head->prev);
}

static inline __attribute__((no_instrument_function)) void __list_cut_posit=
ion(struct list_head *list,
  struct list_head *head, struct list_head *entry)
{
 struct list_head *new_first =3D entry->next;
 list->next =3D head->next;
 list->next->prev =3D list;
 list->prev =3D entry;
 entry->next =3D list;
 head->next =3D new_first;
 new_first->prev =3D head;
}
# 259 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void list_cut_positio=
n(struct list_head *list,
  struct list_head *head, struct list_head *entry)
{
 if (list_empty(head))
  return;
 if (list_is_singular(head) &&
  (head->next !=3D entry && head !=3D entry))
  return;
 if (entry =3D=3D head)
  INIT_LIST_HEAD(list);
 else
  __list_cut_position(list, head, entry);
}

static inline __attribute__((no_instrument_function)) void __list_splice(co=
nst struct list_head *list,
     struct list_head *prev,
     struct list_head *next)
{
 struct list_head *first =3D list->next;
 struct list_head *last =3D list->prev;

 first->prev =3D prev;
 prev->next =3D first;

 last->next =3D next;
 next->prev =3D last;
}






static inline __attribute__((no_instrument_function)) void list_splice(cons=
t struct list_head *list,
    struct list_head *head)
{
 if (!list_empty(list))
  __list_splice(list, head, head->next);
}






static inline __attribute__((no_instrument_function)) void list_splice_tail=
(struct list_head *list,
    struct list_head *head)
{
 if (!list_empty(list))
  __list_splice(list, head->prev, head);
}
# 318 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void list_splice_init=
(struct list_head *list,
        struct list_head *head)
{
 if (!list_empty(list)) {
  __list_splice(list, head, head->next);
  INIT_LIST_HEAD(list);
 }
}
# 335 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void list_splice_tail=
_init(struct list_head *list,
      struct list_head *head)
{
 if (!list_empty(list)) {
  __list_splice(list, head->prev, head);
  INIT_LIST_HEAD(list);
 }
}
# 570 "/usr/src/linux-2.6/include/linux/list.h"
static inline __attribute__((no_instrument_function)) void INIT_HLIST_NODE(=
struct hlist_node *h)
{
 h->next =3D ((void *)0);
 h->pprev =3D ((void *)0);
}

static inline __attribute__((no_instrument_function)) int hlist_unhashed(co=
nst struct hlist_node *h)
{
 return !h->pprev;
}

static inline __attribute__((no_instrument_function)) int hlist_empty(const=
 struct hlist_head *h)
{
 return !h->first;
}

static inline __attribute__((no_instrument_function)) void __hlist_del(stru=
ct hlist_node *n)
{
 struct hlist_node *next =3D n->next;
 struct hlist_node **pprev =3D n->pprev;
 *pprev =3D next;
 if (next)
  next->pprev =3D pprev;
}

static inline __attribute__((no_instrument_function)) void hlist_del(struct=
 hlist_node *n)
{
 __hlist_del(n);
 n->next =3D ((void *) 0x00100100 + (0x0UL));
 n->pprev =3D ((void *) 0x00200200 + (0x0UL));
}

static inline __attribute__((no_instrument_function)) void hlist_del_init(s=
truct hlist_node *n)
{
 if (!hlist_unhashed(n)) {
  __hlist_del(n);
  INIT_HLIST_NODE(n);
 }
}

static inline __attribute__((no_instrument_function)) void hlist_add_head(s=
truct hlist_node *n, struct hlist_head *h)
{
 struct hlist_node *first =3D h->first;
 n->next =3D first;
 if (first)
  first->pprev =3D &n->next;
 h->first =3D n;
 n->pprev =3D &h->first;
}


static inline __attribute__((no_instrument_function)) void hlist_add_before=
(struct hlist_node *n,
     struct hlist_node *next)
{
 n->pprev =3D next->pprev;
 n->next =3D next;
 next->pprev =3D &n->next;
 *(n->pprev) =3D n;
}

static inline __attribute__((no_instrument_function)) void hlist_add_after(=
struct hlist_node *n,
     struct hlist_node *next)
{
 next->next =3D n->next;
 n->next =3D next;
 next->pprev =3D &n->next;

 if(next->next)
  next->next->pprev =3D &next->next;
}


static inline __attribute__((no_instrument_function)) void hlist_add_fake(s=
truct hlist_node *n)
{
 n->pprev =3D &n->next;
}





static inline __attribute__((no_instrument_function)) void hlist_move_list(=
struct hlist_head *old,
       struct hlist_head *new)
{
 new->first =3D old->first;
 if (new->first)
  new->first->pprev =3D &new->first;
 old->first =3D ((void *)0);
}
# 11 "/usr/src/linux-2.6/include/linux/preempt.h" 2







# 1 "/usr/src/linux-2.6/arch/x86/include/asm/preempt.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/asm/rmwcc.h" 1
# 5 "/usr/src/linux-2.6/arch/x86/include/asm/preempt.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/percpu.h" 1
# 44 "/usr/src/linux-2.6/arch/x86/include/asm/percpu.h"
# 1 "/usr/src/linux-2.6/include/linux/kernel.h" 1




# 1 "/usr/lib/gcc/x86_64-linux-gnu/4.8/include/stdarg.h" 1 3 4
# 40 "/usr/lib/gcc/x86_64-linux-gnu/4.8/include/stdarg.h" 3 4
typedef __builtin_va_list __gnuc_va_list;
# 98 "/usr/lib/gcc/x86_64-linux-gnu/4.8/include/stdarg.h" 3 4
typedef __gnuc_va_list va_list;
# 6 "/usr/src/linux-2.6/include/linux/kernel.h" 2




# 1 "/usr/src/linux-2.6/include/linux/bitops.h" 1
# 13 "/usr/src/linux-2.6/include/linux/bitops.h"
extern unsigned int __sw_hweight8(unsigned int w);
extern unsigned int __sw_hweight16(unsigned int w);
extern unsigned int __sw_hweight32(unsigned int w);
extern unsigned long __sw_hweight64(__u64 w);





# 1 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 1
# 16 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/alternative.h" 1






# 1 "/usr/src/linux-2.6/arch/x86/include/asm/asm.h" 1
# 8 "/usr/src/linux-2.6/arch/x86/include/asm/alternative.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/asm/segment.h" 1
# 216 "/usr/src/linux-2.6/arch/x86/include/asm/segment.h"
extern const char early_idt_handlers[32][2+2+5];
# 264 "/usr/src/linux-2.6/arch/x86/include/asm/segment.h"
static inline __attribute__((no_instrument_function)) unsigned long get_lim=
it(unsigned long segment)
{
 unsigned long __limit;
 asm("lsll %1,%0" : "=3Dr" (__limit) : "r" (segment));
 return __limit + 1;
}
# 5 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/page_types.h" 1
# 44 "/usr/src/linux-2.6/arch/x86/include/asm/page_types.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/page_32_types.h" 1
# 51 "/usr/src/linux-2.6/arch/x86/include/asm/page_32_types.h"
extern unsigned int __VMALLOC_RESERVE;
extern int sysctl_legacy_va_layout;

extern void find_low_pfn_range(void);
extern void setup_bootmem_allocator(void);
# 45 "/usr/src/linux-2.6/arch/x86/include/asm/page_types.h" 2




extern int devmem_is_allowed(unsigned long pagenr);

extern unsigned long max_low_pfn_mapped;
extern unsigned long max_pfn_mapped;

static inline __attribute__((no_instrument_function)) phys_addr_t get_max_m=
apped(void)
{
 return (phys_addr_t)max_pfn_mapped << 12;
}

bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);

extern unsigned long init_memory_mapping(unsigned long start,
      unsigned long end);

extern void initmem_init(void);
# 6 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/ptrace.h" 1




# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/ptrace-abi.h" 1
# 6 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/ptrace.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/processor-flags.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/processor-flags.h" 1
# 5 "/usr/src/linux-2.6/arch/x86/include/asm/processor-flags.h" 2
# 7 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/ptrace.h" 2
# 7 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h" 2




struct pt_regs {
 unsigned long bx;
 unsigned long cx;
 unsigned long dx;
 unsigned long si;
 unsigned long di;
 unsigned long bp;
 unsigned long ax;
 unsigned long ds;
 unsigned long es;
 unsigned long fs;
 unsigned long gs;
 unsigned long orig_ax;
 unsigned long ip;
 unsigned long cs;
 unsigned long flags;
 unsigned long sp;
 unsigned long ss;
};
# 63 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h"
# 1 "/usr/src/linux-2.6/include/linux/init.h" 1
# 137 "/usr/src/linux-2.6/include/linux/init.h"
typedef int (*initcall_t)(void);
typedef void (*exitcall_t)(void);

extern initcall_t __con_initcall_start[], __con_initcall_end[];
extern initcall_t __security_initcall_start[], __security_initcall_end[];


typedef void (*ctor_fn_t)(void);


extern int do_one_initcall(initcall_t fn);
extern char __attribute__ ((__section__(".init.data"))) boot_command_line[];
extern char *saved_command_line;
extern unsigned int reset_devices;


void setup_arch(char **);
void prepare_namespace(void);
void __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) =
__attribute__((no_instrument_function)) load_default_modules(void);
int __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) _=
_attribute__((no_instrument_function)) init_rootfs(void);

extern void (*late_time_init)(void);

extern bool initcall_debug;
# 227 "/usr/src/linux-2.6/include/linux/init.h"
struct obs_kernel_param {
 const char *str;
 int (*setup_func)(char *);
 int early;
};
# 256 "/usr/src/linux-2.6/include/linux/init.h"
void __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) =
__attribute__((no_instrument_function)) parse_early_param(void);
void __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) =
__attribute__((no_instrument_function)) parse_early_options(char *cmdline);
# 64 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h" 2




struct cpuinfo_x86;
struct task_struct;

extern unsigned long profile_pc(struct pt_regs *regs);


extern unsigned long
convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
    int error_code, int si_code);

extern long syscall_trace_enter(struct pt_regs *);
extern void syscall_trace_leave(struct pt_regs *);

static inline __attribute__((no_instrument_function)) unsigned long regs_re=
turn_value(struct pt_regs *regs)
{
 return regs->ax;
}
# 94 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h"
static inline __attribute__((no_instrument_function)) int user_mode(struct =
pt_regs *regs)
{

 return (regs->cs & 0x3) =3D=3D 0x3;



}

static inline __attribute__((no_instrument_function)) int user_mode_vm(stru=
ct pt_regs *regs)
{

 return ((regs->cs & 0x3) | (regs->flags & ((1UL) << (17)))) >=3D
  0x3;



}

static inline __attribute__((no_instrument_function)) int v8086_mode(struct=
 pt_regs *regs)
{

 return (regs->flags & ((1UL) << (17)));



}
# 146 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h"
extern unsigned long kernel_stack_pointer(struct pt_regs *regs);
# 158 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h"
# 1 "/usr/src/linux-2.6/include/asm-generic/ptrace.h" 1
# 22 "/usr/src/linux-2.6/include/asm-generic/ptrace.h"
static inline __attribute__((no_instrument_function)) unsigned long instruc=
tion_pointer(struct pt_regs *regs)
{
 return ((regs)->ip);
}
static inline __attribute__((no_instrument_function)) void instruction_poin=
ter_set(struct pt_regs *regs,
                                           unsigned long val)
{
 (((regs)->ip) =3D (val));
}
# 44 "/usr/src/linux-2.6/include/asm-generic/ptrace.h"
static inline __attribute__((no_instrument_function)) unsigned long user_st=
ack_pointer(struct pt_regs *regs)
{
 return ((regs)->sp);
}
static inline __attribute__((no_instrument_function)) void user_stack_point=
er_set(struct pt_regs *regs,
                                          unsigned long val)
{
 (((regs)->sp) =3D (val));
}
# 62 "/usr/src/linux-2.6/include/asm-generic/ptrace.h"
static inline __attribute__((no_instrument_function)) unsigned long frame_p=
ointer(struct pt_regs *regs)
{
 return ((regs)->bp);
}
static inline __attribute__((no_instrument_function)) void frame_pointer_se=
t(struct pt_regs *regs,
                                     unsigned long val)
{
 (((regs)->bp) =3D (val));
}
# 159 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h" 2


extern int regs_query_register_offset(const char *name);
extern const char *regs_query_register_name(unsigned int offset);
# 174 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h"
static inline __attribute__((no_instrument_function)) unsigned long regs_ge=
t_register(struct pt_regs *regs,
           unsigned int offset)
{
 if (__builtin_expect(!!(offset > (__builtin_offsetof(struct pt_regs,ss))),=
 0))
  return 0;





 if (offset =3D=3D __builtin_offsetof(struct pt_regs,sp) &&
     regs->cs =3D=3D (((12)+0)*8))
  return kernel_stack_pointer(regs);

 return *(unsigned long *)((unsigned long)regs + offset);
}
# 199 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h"
static inline __attribute__((no_instrument_function)) int regs_within_kerne=
l_stack(struct pt_regs *regs,
        unsigned long addr)
{
 return ((addr & ~((((1UL) << 12) << 1) - 1)) =3D=3D
  (kernel_stack_pointer(regs) & ~((((1UL) << 12) << 1) - 1)));
}
# 215 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h"
static inline __attribute__((no_instrument_function)) unsigned long regs_ge=
t_kernel_stack_nth(struct pt_regs *regs,
            unsigned int n)
{
 unsigned long *addr =3D (unsigned long *)kernel_stack_pointer(regs);
 addr +=3D n;
 if (regs_within_kernel_stack(regs, (unsigned long)addr))
  return *addr;
 else
  return 0;
}
# 235 "/usr/src/linux-2.6/arch/x86/include/asm/ptrace.h"
struct user_desc;
extern int do_get_thread_area(struct task_struct *p, int idx,
         struct user_desc *info);
extern int do_set_thread_area(struct task_struct *p, int idx,
         struct user_desc *info, int can_allocate);
# 9 "/usr/src/linux-2.6/arch/x86/include/asm/alternative.h" 2
# 46 "/usr/src/linux-2.6/arch/x86/include/asm/alternative.h"
struct alt_instr {
 s32 instr_offset;
 s32 repl_offset;
 u16 cpuid;
 u8 instrlen;
 u8 replacementlen;
};

extern void alternative_instructions(void);
extern void apply_alternatives(struct alt_instr *start, struct alt_instr *e=
nd);

struct module;
# 68 "/usr/src/linux-2.6/arch/x86/include/asm/alternative.h"
static inline __attribute__((no_instrument_function)) void alternatives_smp=
_module_add(struct module *mod, char *name,
            void *locks, void *locks_end,
            void *text, void *text_end) {}
static inline __attribute__((no_instrument_function)) void alternatives_smp=
_module_del(struct module *mod) {}
static inline __attribute__((no_instrument_function)) void alternatives_ena=
ble_smp(void) {}
static inline __attribute__((no_instrument_function)) int alternatives_text=
_reserved(void *start, void *end)
{
 return 0;
}
# 132 "/usr/src/linux-2.6/arch/x86/include/asm/alternative.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h" 1







# 1 "/usr/src/linux-2.6/arch/x86/include/asm/required-features.h" 1
# 9 "/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h" 2
# 237 "/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h"
# 1 "/usr/src/linux-2.6/include/linux/bitops.h" 1
# 238 "/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h" 2

extern const char * const x86_cap_flags[10*32];
extern const char * const x86_power_flags[32];
# 359 "/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h"
extern void warn_pre_alternatives(void);
extern bool __static_cpu_has_safe(u16 bit);






static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) __attribute__((pure)) bool __static_cpu_has(u16 bit)
{
# 391 "/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h"
  asm goto("1: jmp %l[t_no]\n"
    "2:\n"
    ".section .altinstructions,\"a\"\n"
    " .long 1b - .\n"
    " .long 0\n"
    " .word %P0\n"
    " .byte 2b - 1b\n"
    " .byte 0\n"
    ".previous\n"

    : : "i" (bit) : : t_no);
  return true;
 t_no:
  return false;
# 436 "/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h"
}
# 447 "/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) __attribute__((pure)) bool _static_cpu_has_safe(u16 bit)
{







  asm goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
    "2:\n"
    ".section .altinstructions,\"a\"\n"
    " .long 1b - .\n"
    " .long 3f - .\n"
    " .word %P1\n"
    " .byte 2b - 1b\n"
    " .byte 4f - 3f\n"
    ".previous\n"
    ".section .altinstr_replacement,\"ax\"\n"
    "3: .byte 0xe9\n .long %l[t_no] - 2b\n"
    "4:\n"
    ".previous\n"
    ".section .altinstructions,\"a\"\n"
    " .long 1b - .\n"
    " .long 0\n"
    " .word %P0\n"
    " .byte 2b - 1b\n"
    " .byte 0\n"
    ".previous\n"
    : : "i" (bit), "i" ((3*32+21))
    : : t_dynamic, t_no);
  return true;
 t_no:
  return false;
 t_dynamic:
  return __static_cpu_has_safe(bit);
# 520 "/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h"
}
# 133 "/usr/src/linux-2.6/arch/x86/include/asm/alternative.h" 2
# 199 "/usr/src/linux-2.6/arch/x86/include/asm/alternative.h"
struct paravirt_patch_site;




static inline __attribute__((no_instrument_function)) void apply_paravirt(s=
truct paravirt_patch_site *start,
      struct paravirt_patch_site *end)
{}




extern void *text_poke_early(void *addr, const void *opcode, size_t len);
# 227 "/usr/src/linux-2.6/arch/x86/include/asm/alternative.h"
extern void *text_poke(void *addr, const void *opcode, size_t len);
extern int poke_int3_handler(struct pt_regs *regs);
extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void =
*handler);
# 17 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 2
# 70 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void
set_bit(long nr, volatile unsigned long *addr)
{
 if ((__builtin_constant_p(nr))) {
  asm volatile("" "orb %1,%0"
   : "+m" (*(volatile long *) ((void *)(addr) + ((nr)>>3)))
   : "iq" ((u8)(1 << ((nr) & 7)))
   : "memory");
 } else {
  asm volatile("" "bts %1,%0"
   : "+m" (*(volatile long *) (addr)) : "Ir" (nr) : "memory");
 }
}
# 93 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) void __set_bit(long n=
r, volatile unsigned long *addr)
{
 asm volatile("bts %1,%0" : "+m" (*(volatile long *) (addr)) : "Ir" (nr) : =
"memory");
}
# 108 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void
clear_bit(long nr, volatile unsigned long *addr)
{
 if ((__builtin_constant_p(nr))) {
  asm volatile("" "andb %1,%0"
   : "+m" (*(volatile long *) ((void *)(addr) + ((nr)>>3)))
   : "iq" ((u8)~(1 << ((nr) & 7))));
 } else {
  asm volatile("" "btr %1,%0"
   : "+m" (*(volatile long *) (addr))
   : "Ir" (nr));
 }
}
# 130 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) void clear_bit_unlock=
(long nr, volatile unsigned long *addr)
{
 __asm__ __volatile__("": : :"memory");
 clear_bit(nr, addr);
}

static inline __attribute__((no_instrument_function)) void __clear_bit(long=
 nr, volatile unsigned long *addr)
{
 asm volatile("btr %1,%0" : "+m" (*(volatile long *) (addr)) : "Ir" (nr));
}
# 153 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) void __clear_bit_unlo=
ck(long nr, volatile unsigned long *addr)
{
 __asm__ __volatile__("": : :"memory");
 __clear_bit(nr, addr);
}
# 171 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) void __change_bit(lon=
g nr, volatile unsigned long *addr)
{
 asm volatile("btc %1,%0" : "+m" (*(volatile long *) (addr)) : "Ir" (nr));
}
# 185 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) void change_bit(long =
nr, volatile unsigned long *addr)
{
 if ((__builtin_constant_p(nr))) {
  asm volatile("" "xorb %1,%0"
   : "+m" (*(volatile long *) ((void *)(addr) + ((nr)>>3)))
   : "iq" ((u8)(1 << ((nr) & 7))));
 } else {
  asm volatile("" "btc %1,%0"
   : "+m" (*(volatile long *) (addr))
   : "Ir" (nr));
 }
}
# 206 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) int test_and_set_bit(=
long nr, volatile unsigned long *addr)
{
 do { asm volatile goto ("" "bts" " %1, " "%0" "; j" "c" " %l[cc_label]" : =
: "m" (*addr), "er" (nr) : "memory" : cc_label); return 0; cc_label: return=
 1; } while (0);
}
# 218 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) int
test_and_set_bit_lock(long nr, volatile unsigned long *addr)
{
 return test_and_set_bit(nr, addr);
}
# 233 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) int __test_and_set_bi=
t(long nr, volatile unsigned long *addr)
{
 int oldbit;

 asm("bts %2,%1\n\t"
     "sbb %0,%0"
     : "=3Dr" (oldbit), "+m" (*(volatile long *) (addr))
     : "Ir" (nr));
 return oldbit;
}
# 252 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) int test_and_clear_bi=
t(long nr, volatile unsigned long *addr)
{
 do { asm volatile goto ("" "btr" " %1, " "%0" "; j" "c" " %l[cc_label]" : =
: "m" (*addr), "er" (nr) : "memory" : cc_label); return 0; cc_label: return=
 1; } while (0);
}
# 273 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) int __test_and_clear_=
bit(long nr, volatile unsigned long *addr)
{
 int oldbit;

 asm volatile("btr %2,%1\n\t"
       "sbb %0,%0"
       : "=3Dr" (oldbit), "+m" (*(volatile long *) (addr))
       : "Ir" (nr));
 return oldbit;
}


static inline __attribute__((no_instrument_function)) int __test_and_change=
_bit(long nr, volatile unsigned long *addr)
{
 int oldbit;

 asm volatile("btc %2,%1\n\t"
       "sbb %0,%0"
       : "=3Dr" (oldbit), "+m" (*(volatile long *) (addr))
       : "Ir" (nr) : "memory");

 return oldbit;
}
# 305 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) int test_and_change_b=
it(long nr, volatile unsigned long *addr)
{
 do { asm volatile goto ("" "btc" " %1, " "%0" "; j" "c" " %l[cc_label]" : =
: "m" (*addr), "er" (nr) : "memory" : cc_label); return 0; cc_label: return=
 1; } while (0);
}

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) int constant_test_bit(long nr, const volatile unsigned long *addr)
{
 return ((1UL << (nr & (32 -1))) &
  (addr[nr >> 5])) !=3D 0;
}

static inline __attribute__((no_instrument_function)) int variable_test_bit=
(long nr, volatile const unsigned long *addr)
{
 int oldbit;

 asm volatile("bt %2,%1\n\t"
       "sbb %0,%0"
       : "=3Dr" (oldbit)
       : "m" (*(unsigned long *)addr), "Ir" (nr));

 return oldbit;
}
# 348 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) unsigned long __ffs(u=
nsigned long word)
{
 asm("rep; bsf %1,%0"
  : "=3Dr" (word)
  : "rm" (word));
 return word;
}







static inline __attribute__((no_instrument_function)) unsigned long ffz(uns=
igned long word)
{
 asm("rep; bsf %1,%0"
  : "=3Dr" (word)
  : "r" (~word));
 return word;
}







static inline __attribute__((no_instrument_function)) unsigned long __fls(u=
nsigned long word)
{
 asm("bsr %1,%0"
     : "=3Dr" (word)
     : "rm" (word));
 return word;
}
# 398 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) int ffs(int x)
{
 int r;
# 416 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
 asm("bsfl %1,%0\n\t"
     "cmovzl %2,%0"
     : "=3D&r" (r) : "rm" (x), "r" (-1));






 return r + 1;
}
# 439 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
static inline __attribute__((no_instrument_function)) int fls(int x)
{
 int r;
# 457 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
 asm("bsrl %1,%0\n\t"
     "cmovzl %2,%0"
     : "=3D&r" (r) : "rm" (x), "rm" (-1));






 return r + 1;
}
# 495 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h"
# 1 "/usr/src/linux-2.6/include/asm-generic/bitops/fls64.h" 1
# 18 "/usr/src/linux-2.6/include/asm-generic/bitops/fls64.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) int fls64(__u64 x)
{
 __u32 h =3D x >> 32;
 if (h)
  return fls(h) + 32;
 return fls(x);
}
# 496 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 2


# 1 "/usr/src/linux-2.6/include/asm-generic/bitops/find.h" 1
# 11 "/usr/src/linux-2.6/include/asm-generic/bitops/find.h"
extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
  size, unsigned long offset);
# 22 "/usr/src/linux-2.6/include/asm-generic/bitops/find.h"
extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
  long size, unsigned long offset);
# 35 "/usr/src/linux-2.6/include/asm-generic/bitops/find.h"
extern unsigned long find_first_bit(const unsigned long *addr,
        unsigned long size);
# 45 "/usr/src/linux-2.6/include/asm-generic/bitops/find.h"
extern unsigned long find_first_zero_bit(const unsigned long *addr,
      unsigned long size);
# 499 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 2

# 1 "/usr/src/linux-2.6/include/asm-generic/bitops/sched.h" 1
# 12 "/usr/src/linux-2.6/include/asm-generic/bitops/sched.h"
static inline __attribute__((no_instrument_function)) int sched_find_first_=
bit(const unsigned long *b)
{





 if (b[0])
  return __ffs(b[0]);
 if (b[1])
  return __ffs(b[1]) + 32;
 if (b[2])
  return __ffs(b[2]) + 64;
 return __ffs(b[3]) + 96;



}
# 501 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 2



# 1 "/usr/src/linux-2.6/arch/x86/include/asm/arch_hweight.h" 1
# 24 "/usr/src/linux-2.6/arch/x86/include/asm/arch_hweight.h"
static inline __attribute__((no_instrument_function)) unsigned int __arch_h=
weight32(unsigned int w)
{
 unsigned int res =3D 0;

 asm ("661:\n\t" "call __sw_hweight32" "\n662:\n" ".pushsection .altinstruc=
tions,\"a\"\n" " .long 661b - .\n" " .long " "663""1""f - .\n" " .word " "(=
4*32+23)" "\n" " .byte " "662b-661b" "\n" " .byte " "664""1""f-""663""1""f"=
 "\n" ".popsection\n" ".pushsection .discard,\"aw\",@progbits\n" " .byte 0x=
ff + (" "664""1""f-""663""1""f" ") - (" "662b-661b" ")\n" ".popsection\n" "=
=2Epushsection .altinstr_replacement, \"ax\"\n" "663""1"":\n\t" ".byte 0xf3=
,0x0f,0xb8,0xc0" "\n" "664""1" ":\n\t" ".popsection"
       : "=3D""a" (res)
       : "a" (w));

 return res;
}

static inline __attribute__((no_instrument_function)) unsigned int __arch_h=
weight16(unsigned int w)
{
 return __arch_hweight32(w & 0xffff);
}

static inline __attribute__((no_instrument_function)) unsigned int __arch_h=
weight8(unsigned int w)
{
 return __arch_hweight32(w & 0xff);
}

static inline __attribute__((no_instrument_function)) unsigned long __arch_=
hweight64(__u64 w)
{
 unsigned long res =3D 0;


 return __arch_hweight32((u32)w) +
  __arch_hweight32((u32)(w >> 32));






 return res;
}
# 505 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 2

# 1 "/usr/src/linux-2.6/include/asm-generic/bitops/const_hweight.h" 1
# 507 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 2

# 1 "/usr/src/linux-2.6/include/asm-generic/bitops/le.h" 1




# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/byteorder.h" 1



# 1 "/usr/src/linux-2.6/include/linux/byteorder/little_endian.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/byteorder/little_endian.h" 1
# 12 "/usr/src/linux-2.6/include/uapi/linux/byteorder/little_endian.h"
# 1 "/usr/src/linux-2.6/include/linux/swab.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/swab.h" 1





# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/swab.h" 1






static inline __attribute__((no_instrument_function)) __attribute__((__cons=
t__)) __u32 __arch_swab32(__u32 val)
{
 asm("bswapl %0" : "=3Dr" (val) : "0" (val));
 return val;
}


static inline __attribute__((no_instrument_function)) __attribute__((__cons=
t__)) __u64 __arch_swab64(__u64 val)
{

 union {
  struct {
   __u32 a;
   __u32 b;
  } s;
  __u64 u;
 } v;
 v.u =3D val;
 asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
     : "=3Dr" (v.s.a), "=3Dr" (v.s.b)
     : "0" (v.s.a), "1" (v.s.b));
 return v.u;




}
# 7 "/usr/src/linux-2.6/include/uapi/linux/swab.h" 2
# 46 "/usr/src/linux-2.6/include/uapi/linux/swab.h"
static inline __attribute__((no_instrument_function)) __attribute__((__cons=
t__)) __u16 __fswab16(__u16 val)
{

 return __builtin_bswap16(val);





}

static inline __attribute__((no_instrument_function)) __attribute__((__cons=
t__)) __u32 __fswab32(__u32 val)
{

 return __builtin_bswap32(val);





}

static inline __attribute__((no_instrument_function)) __attribute__((__cons=
t__)) __u64 __fswab64(__u64 val)
{

 return __builtin_bswap64(val);
# 81 "/usr/src/linux-2.6/include/uapi/linux/swab.h"
}

static inline __attribute__((no_instrument_function)) __attribute__((__cons=
t__)) __u32 __fswahw32(__u32 val)
{



 return ((__u32)( (((__u32)(val) & (__u32)0x0000ffffUL) << 16) | (((__u32)(=
val) & (__u32)0xffff0000UL) >> 16)));

}

static inline __attribute__((no_instrument_function)) __attribute__((__cons=
t__)) __u32 __fswahb32(__u32 val)
{



 return ((__u32)( (((__u32)(val) & (__u32)0x00ff00ffUL) << 8) | (((__u32)(v=
al) & (__u32)0xff00ff00UL) >> 8)));

}
# 154 "/usr/src/linux-2.6/include/uapi/linux/swab.h"
static inline __attribute__((no_instrument_function)) __u16 __swab16p(const=
 __u16 *p)
{



 return (__builtin_constant_p((__u16)(*p)) ? ((__u16)( (((__u16)(*p) & (__u=
16)0x00ffU) << 8) | (((__u16)(*p) & (__u16)0xff00U) >> 8))) : __fswab16(*p)=
);

}





static inline __attribute__((no_instrument_function)) __u32 __swab32p(const=
 __u32 *p)
{



 return (__builtin_constant_p((__u32)(*p)) ? ((__u32)( (((__u32)(*p) & (__u=
32)0x000000ffUL) << 24) | (((__u32)(*p) & (__u32)0x0000ff00UL) << 8) | (((_=
_u32)(*p) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(*p) & (__u32)0xff000000U=
L) >> 24))) : __fswab32(*p));

}





static inline __attribute__((no_instrument_function)) __u64 __swab64p(const=
 __u64 *p)
{



 return (__builtin_constant_p((__u64)(*p)) ? ((__u64)( (((__u64)(*p) & (__u=
64)0x00000000000000ffULL) << 56) | (((__u64)(*p) & (__u64)0x000000000000ff0=
0ULL) << 40) | (((__u64)(*p) & (__u64)0x0000000000ff0000ULL) << 24) | (((__=
u64)(*p) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(*p) & (__u64)0x0=
00000ff00000000ULL) >> 8) | (((__u64)(*p) & (__u64)0x0000ff0000000000ULL) >=
> 24) | (((__u64)(*p) & (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(*p=
) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(*p));

}







static inline __attribute__((no_instrument_function)) __u32 __swahw32p(cons=
t __u32 *p)
{



 return (__builtin_constant_p((__u32)(*p)) ? ((__u32)( (((__u32)(*p) & (__u=
32)0x0000ffffUL) << 16) | (((__u32)(*p) & (__u32)0xffff0000UL) >> 16))) : _=
_fswahw32(*p));

}







static inline __attribute__((no_instrument_function)) __u32 __swahb32p(cons=
t __u32 *p)
{



 return (__builtin_constant_p((__u32)(*p)) ? ((__u32)( (((__u32)(*p) & (__u=
32)0x00ff00ffUL) << 8) | (((__u32)(*p) & (__u32)0xff00ff00UL) >> 8))) : __f=
swahb32(*p));

}





static inline __attribute__((no_instrument_function)) void __swab16s(__u16 =
*p)
{



 *p =3D __swab16p(p);

}




static inline __attribute__((no_instrument_function)) void __swab32s(__u32 =
*p)
{



 *p =3D __swab32p(p);

}





static inline __attribute__((no_instrument_function)) void __swab64s(__u64 =
*p)
{



 *p =3D __swab64p(p);

}







static inline __attribute__((no_instrument_function)) void __swahw32s(__u32=
 *p)
{



 *p =3D __swahw32p(p);

}







static inline __attribute__((no_instrument_function)) void __swahb32s(__u32=
 *p)
{



 *p =3D __swahb32p(p);

}
# 5 "/usr/src/linux-2.6/include/linux/swab.h" 2
# 13 "/usr/src/linux-2.6/include/uapi/linux/byteorder/little_endian.h" 2
# 43 "/usr/src/linux-2.6/include/uapi/linux/byteorder/little_endian.h"
static inline __attribute__((no_instrument_function)) __le64 __cpu_to_le64p=
(const __u64 *p)
{
 return ( __le64)*p;
}
static inline __attribute__((no_instrument_function)) __u64 __le64_to_cpup(=
const __le64 *p)
{
 return ( __u64)*p;
}
static inline __attribute__((no_instrument_function)) __le32 __cpu_to_le32p=
(const __u32 *p)
{
 return ( __le32)*p;
}
static inline __attribute__((no_instrument_function)) __u32 __le32_to_cpup(=
const __le32 *p)
{
 return ( __u32)*p;
}
static inline __attribute__((no_instrument_function)) __le16 __cpu_to_le16p=
(const __u16 *p)
{
 return ( __le16)*p;
}
static inline __attribute__((no_instrument_function)) __u16 __le16_to_cpup(=
const __le16 *p)
{
 return ( __u16)*p;
}
static inline __attribute__((no_instrument_function)) __be64 __cpu_to_be64p=
(const __u64 *p)
{
 return ( __be64)__swab64p(p);
}
static inline __attribute__((no_instrument_function)) __u64 __be64_to_cpup(=
const __be64 *p)
{
 return __swab64p((__u64 *)p);
}
static inline __attribute__((no_instrument_function)) __be32 __cpu_to_be32p=
(const __u32 *p)
{
 return ( __be32)__swab32p(p);
}
static inline __attribute__((no_instrument_function)) __u32 __be32_to_cpup(=
const __be32 *p)
{
 return __swab32p((__u32 *)p);
}
static inline __attribute__((no_instrument_function)) __be16 __cpu_to_be16p=
(const __u16 *p)
{
 return ( __be16)__swab16p(p);
}
static inline __attribute__((no_instrument_function)) __u16 __be16_to_cpup(=
const __be16 *p)
{
 return __swab16p((__u16 *)p);
}
# 5 "/usr/src/linux-2.6/include/linux/byteorder/little_endian.h" 2

# 1 "/usr/src/linux-2.6/include/linux/byteorder/generic.h" 1
# 143 "/usr/src/linux-2.6/include/linux/byteorder/generic.h"
static inline __attribute__((no_instrument_function)) void le16_add_cpu(__l=
e16 *var, u16 val)
{
 *var =3D (( __le16)(__u16)((( __u16)(__le16)(*var)) + val));
}

static inline __attribute__((no_instrument_function)) void le32_add_cpu(__l=
e32 *var, u32 val)
{
 *var =3D (( __le32)(__u32)((( __u32)(__le32)(*var)) + val));
}

static inline __attribute__((no_instrument_function)) void le64_add_cpu(__l=
e64 *var, u64 val)
{
 *var =3D (( __le64)(__u64)((( __u64)(__le64)(*var)) + val));
}

static inline __attribute__((no_instrument_function)) void be16_add_cpu(__b=
e16 *var, u16 val)
{
 *var =3D (( __be16)(__builtin_constant_p((__u16)(((__builtin_constant_p((_=
_u16)(( __u16)(__be16)(*var))) ? ((__u16)( (((__u16)(( __u16)(__be16)(*var)=
) & (__u16)0x00ffU) << 8) | (((__u16)(( __u16)(__be16)(*var)) & (__u16)0xff=
00U) >> 8))) : __fswab16(( __u16)(__be16)(*var))) + val))) ? ((__u16)( (((_=
_u16)(((__builtin_constant_p((__u16)(( __u16)(__be16)(*var))) ? ((__u16)( (=
((__u16)(( __u16)(__be16)(*var)) & (__u16)0x00ffU) << 8) | (((__u16)(( __u1=
6)(__be16)(*var)) & (__u16)0xff00U) >> 8))) : __fswab16(( __u16)(__be16)(*v=
ar))) + val)) & (__u16)0x00ffU) << 8) | (((__u16)(((__builtin_constant_p((_=
_u16)(( __u16)(__be16)(*var))) ? ((__u16)( (((__u16)(( __u16)(__be16)(*var)=
) & (__u16)0x00ffU) << 8) | (((__u16)(( __u16)(__be16)(*var)) & (__u16)0xff=
00U) >> 8))) : __fswab16(( __u16)(__be16)(*var))) + val)) & (__u16)0xff00U)=
 >> 8))) : __fswab16(((__builtin_constant_p((__u16)(( __u16)(__be16)(*var))=
) ? ((__u16)( (((__u16)(( __u16)(__be16)(*var)) & (__u16)0x00ffU) << 8) | (=
((__u16)(( __u16)(__be16)(*var)) & (__u16)0xff00U) >> 8))) : __fswab16(( __=
u16)(__be16)(*var))) + val))));
}

static inline __attribute__((no_instrument_function)) void be32_add_cpu(__b=
e32 *var, u32 val)
{
 *var =3D (( __be32)(__builtin_constant_p((__u32)(((__builtin_constant_p((_=
_u32)(( __u32)(__be32)(*var))) ? ((__u32)( (((__u32)(( __u32)(__be32)(*var)=
) & (__u32)0x000000ffUL) << 24) | (((__u32)(( __u32)(__be32)(*var)) & (__u3=
2)0x0000ff00UL) << 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x00ff00=
00UL) >> 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0xff000000UL) >> 2=
4))) : __fswab32(( __u32)(__be32)(*var))) + val))) ? ((__u32)( (((__u32)(((=
__builtin_constant_p((__u32)(( __u32)(__be32)(*var))) ? ((__u32)( (((__u32)=
(( __u32)(__be32)(*var)) & (__u32)0x000000ffUL) << 24) | (((__u32)(( __u32)=
(__be32)(*var)) & (__u32)0x0000ff00UL) << 8) | (((__u32)(( __u32)(__be32)(*=
var)) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(( __u32)(__be32)(*var)) & (_=
_u32)0xff000000UL) >> 24))) : __fswab32(( __u32)(__be32)(*var))) + val)) & =
(__u32)0x000000ffUL) << 24) | (((__u32)(((__builtin_constant_p((__u32)(( __=
u32)(__be32)(*var))) ? ((__u32)( (((__u32)(( __u32)(__be32)(*var)) & (__u32=
)0x000000ffUL) << 24) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x0000ff=
00UL) << 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x00ff0000UL) >> 8=
) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0xff000000UL) >> 24))) : __f=
swab32(( __u32)(__be32)(*var))) + val)) & (__u32)0x0000ff00UL) << 8) | (((_=
_u32)(((__builtin_constant_p((__u32)(( __u32)(__be32)(*var))) ? ((__u32)( (=
((__u32)(( __u32)(__be32)(*var)) & (__u32)0x000000ffUL) << 24) | (((__u32)(=
( __u32)(__be32)(*var)) & (__u32)0x0000ff00UL) << 8) | (((__u32)(( __u32)(_=
_be32)(*var)) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(( __u32)(__be32)(*va=
r)) & (__u32)0xff000000UL) >> 24))) : __fswab32(( __u32)(__be32)(*var))) + =
val)) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(((__builtin_constant_p((__u3=
2)(( __u32)(__be32)(*var))) ? ((__u32)( (((__u32)(( __u32)(__be32)(*var)) &=
 (__u32)0x000000ffUL) << 24) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0=
x0000ff00UL) << 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x00ff0000U=
L) >> 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0xff000000UL) >> 24))=
) : __fswab32(( __u32)(__be32)(*var))) + val)) & (__u32)0xff000000UL) >> 24=
))) : __fswab32(((__builtin_constant_p((__u32)(( __u32)(__be32)(*var))) ? (=
(__u32)( (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x000000ffUL) << 24) | =
(((__u32)(( __u32)(__be32)(*var)) & (__u32)0x0000ff00UL) << 8) | (((__u32)(=
( __u32)(__be32)(*var)) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(( __u32)(_=
_be32)(*var)) & (__u32)0xff000000UL) >> 24))) : __fswab32(( __u32)(__be32)(=
*var))) + val))));
}

static inline __attribute__((no_instrument_function)) void be64_add_cpu(__b=
e64 *var, u64 val)
{
 *var =3D (( __be64)(__builtin_constant_p((__u64)(((__builtin_constant_p((_=
_u64)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)=
) & (__u64)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)=
) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)=
) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)=
) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var))=
 & (__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) =
& (__u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) =
& (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) =
& (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var)=
)) + val))) ? ((__u64)( (((__u64)(((__builtin_constant_p((__u64)(( __u64)(_=
_be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000=
00000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000=
000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000=
0000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000=
00000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000=
00ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000f=
f0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00ff0=
00000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0xff000=
00000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var))) + val)) & (__=
u64)0x00000000000000ffULL) << 56) | (((__u64)(((__builtin_constant_p((__u64=
)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)) & =
(__u64)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)) & =
(__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)) & =
(__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)) & =
(__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var)) & (=
__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) & (_=
_u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) & (_=
_u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) & (_=
_u64)0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var))) +=
 val)) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(((__builtin_const=
ant_p((__u64)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be6=
4)(*var)) & (__u64)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be6=
4)(*var)) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be6=
4)(*var)) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be6=
4)(*var)) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64=
)(*var)) & (__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)=
(*var)) & (__u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)=
(*var)) & (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)=
(*var)) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be6=
4)(*var))) + val)) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(((__b=
uiltin_constant_p((__u64)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( =
__u64)(__be64)(*var)) & (__u64)0x00000000000000ffULL) << 56) | (((__u64)(( =
__u64)(__be64)(*var)) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( =
__u64)(__be64)(*var)) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( =
__u64)(__be64)(*var)) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( _=
_u64)(__be64)(*var)) & (__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __=
u64)(__be64)(*var)) & (__u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __=
u64)(__be64)(*var)) & (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __=
u64)(__be64)(*var)) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(( =
__u64)(__be64)(*var))) + val)) & (__u64)0x00000000ff000000ULL) << 8) | (((_=
_u64)(((__builtin_constant_p((__u64)(( __u64)(__be64)(*var))) ? ((__u64)( (=
((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000000000ffULL) << 56) | (=
((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000000000ff00ULL) << 40) | (=
((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000000000ff0000ULL) << 24) | (=
((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000ff000000ULL) << 8) | ((=
(__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000ff00000000ULL) >> 8) | (((=
__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000ff0000000000ULL) >> 24) | (((=
__u64)(( __u64)(__be64)(*var)) & (__u64)0x00ff000000000000ULL) >> 40) | (((=
__u64)(( __u64)(__be64)(*var)) & (__u64)0xff00000000000000ULL) >> 56))) : _=
_fswab64(( __u64)(__be64)(*var))) + val)) & (__u64)0x000000ff00000000ULL) >=
> 8) | (((__u64)(((__builtin_constant_p((__u64)(( __u64)(__be64)(*var))) ? =
((__u64)( (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000000000ffULL)=
 << 56) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000000000ff00ULL)=
 << 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000000000ff0000ULL)=
 << 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000ff000000ULL)=
 << 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000ff00000000ULL) =
>> 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000ff0000000000ULL) >=
> 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00ff000000000000ULL) >=
> 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0xff00000000000000ULL) >=
> 56))) : __fswab64(( __u64)(__be64)(*var))) + val)) & (__u64)0x0000ff00000=
00000ULL) >> 24) | (((__u64)(((__builtin_constant_p((__u64)(( __u64)(__be64=
)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000=
000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000=
0000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000=
00ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000=
ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000ff0=
0000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000ff0000=
000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00ff000000=
000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0xff00000000=
000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var))) + val)) & (__u64)0=
x00ff000000000000ULL) >> 40) | (((__u64)(((__builtin_constant_p((__u64)(( _=
_u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)) & (__u6=
4)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)) & (__u6=
4)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u6=
4)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u6=
4)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64=
)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)=
0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)=
0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)=
0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var))) + val)=
) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(((__builtin_constant=
_p((__u64)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(=
*var)) & (__u64)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(=
*var)) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(=
*var)) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(=
*var)) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*=
var)) & (__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*v=
ar)) & (__u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*v=
ar)) & (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*v=
ar)) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(=
*var))) + val))));
}
# 7 "/usr/src/linux-2.6/include/linux/byteorder/little_endian.h" 2
# 5 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/byteorder.h" 2
# 6 "/usr/src/linux-2.6/include/asm-generic/bitops/le.h" 2





static inline __attribute__((no_instrument_function)) unsigned long find_ne=
xt_zero_bit_le(const void *addr,
  unsigned long size, unsigned long offset)
{
 return find_next_zero_bit(addr, size, offset);
}

static inline __attribute__((no_instrument_function)) unsigned long find_ne=
xt_bit_le(const void *addr,
  unsigned long size, unsigned long offset)
{
 return find_next_bit(addr, size, offset);
}

static inline __attribute__((no_instrument_function)) unsigned long find_fi=
rst_zero_bit_le(const void *addr,
  unsigned long size)
{
 return find_first_zero_bit(addr, size);
}
# 52 "/usr/src/linux-2.6/include/asm-generic/bitops/le.h"
static inline __attribute__((no_instrument_function)) int test_bit_le(int n=
r, const void *addr)
{
 return (__builtin_constant_p((nr ^ 0)) ? constant_test_bit((nr ^ 0), (addr=
)) : variable_test_bit((nr ^ 0), (addr)));
}

static inline __attribute__((no_instrument_function)) void set_bit_le(int n=
r, void *addr)
{
 set_bit(nr ^ 0, addr);
}

static inline __attribute__((no_instrument_function)) void clear_bit_le(int=
 nr, void *addr)
{
 clear_bit(nr ^ 0, addr);
}

static inline __attribute__((no_instrument_function)) void __set_bit_le(int=
 nr, void *addr)
{
 __set_bit(nr ^ 0, addr);
}

static inline __attribute__((no_instrument_function)) void __clear_bit_le(i=
nt nr, void *addr)
{
 __clear_bit(nr ^ 0, addr);
}

static inline __attribute__((no_instrument_function)) int test_and_set_bit_=
le(int nr, void *addr)
{
 return test_and_set_bit(nr ^ 0, addr);
}

static inline __attribute__((no_instrument_function)) int test_and_clear_bi=
t_le(int nr, void *addr)
{
 return test_and_clear_bit(nr ^ 0, addr);
}

static inline __attribute__((no_instrument_function)) int __test_and_set_bi=
t_le(int nr, void *addr)
{
 return __test_and_set_bit(nr ^ 0, addr);
}

static inline __attribute__((no_instrument_function)) int __test_and_clear_=
bit_le(int nr, void *addr)
{
 return __test_and_clear_bit(nr ^ 0, addr);
}
# 509 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 2

# 1 "/usr/src/linux-2.6/include/asm-generic/bitops/ext2-atomic-setbit.h" 1
# 511 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 2
# 23 "/usr/src/linux-2.6/include/linux/bitops.h" 2
# 46 "/usr/src/linux-2.6/include/linux/bitops.h"
static __inline__ __attribute__((no_instrument_function)) int get_bitmask_o=
rder(unsigned int count)
{
 int order;

 order =3D fls(count);
 return order;
}

static __inline__ __attribute__((no_instrument_function)) int get_count_ord=
er(unsigned int count)
{
 int order;

 order =3D fls(count) - 1;
 if (count & (count - 1))
  order++;
 return order;
}

static inline __attribute__((no_instrument_function)) unsigned long hweight=
_long(unsigned long w)
{
 return sizeof(w) =3D=3D 4 ? (__builtin_constant_p(w) ? ((( (!!((w) & (1ULL=
 << 0))) + (!!((w) & (1ULL << 1))) + (!!((w) & (1ULL << 2))) + (!!((w) & (1=
ULL << 3))) + (!!((w) & (1ULL << 4))) + (!!((w) & (1ULL << 5))) + (!!((w) &=
 (1ULL << 6))) + (!!((w) & (1ULL << 7))) ) + ( (!!(((w) >> 8) & (1ULL << 0)=
)) + (!!(((w) >> 8) & (1ULL << 1))) + (!!(((w) >> 8) & (1ULL << 2))) + (!!(=
((w) >> 8) & (1ULL << 3))) + (!!(((w) >> 8) & (1ULL << 4))) + (!!(((w) >> 8=
) & (1ULL << 5))) + (!!(((w) >> 8) & (1ULL << 6))) + (!!(((w) >> 8) & (1ULL=
 << 7))) )) + (( (!!(((w) >> 16) & (1ULL << 0))) + (!!(((w) >> 16) & (1ULL =
<< 1))) + (!!(((w) >> 16) & (1ULL << 2))) + (!!(((w) >> 16) & (1ULL << 3)))=
 + (!!(((w) >> 16) & (1ULL << 4))) + (!!(((w) >> 16) & (1ULL << 5))) + (!!(=
((w) >> 16) & (1ULL << 6))) + (!!(((w) >> 16) & (1ULL << 7))) ) + ( (!!((((=
w) >> 16) >> 8) & (1ULL << 0))) + (!!((((w) >> 16) >> 8) & (1ULL << 1))) + =
(!!((((w) >> 16) >> 8) & (1ULL << 2))) + (!!((((w) >> 16) >> 8) & (1ULL << =
3))) + (!!((((w) >> 16) >> 8) & (1ULL << 4))) + (!!((((w) >> 16) >> 8) & (1=
ULL << 5))) + (!!((((w) >> 16) >> 8) & (1ULL << 6))) + (!!((((w) >> 16) >> =
8) & (1ULL << 7))) ))) : __arch_hweight32(w)) : (__builtin_constant_p(w) ? =
(((( (!!((w) & (1ULL << 0))) + (!!((w) & (1ULL << 1))) + (!!((w) & (1ULL <<=
 2))) + (!!((w) & (1ULL << 3))) + (!!((w) & (1ULL << 4))) + (!!((w) & (1ULL=
 << 5))) + (!!((w) & (1ULL << 6))) + (!!((w) & (1ULL << 7))) ) + ( (!!(((w)=
 >> 8) & (1ULL << 0))) + (!!(((w) >> 8) & (1ULL << 1))) + (!!(((w) >> 8) & =
(1ULL << 2))) + (!!(((w) >> 8) & (1ULL << 3))) + (!!(((w) >> 8) & (1ULL << =
4))) + (!!(((w) >> 8) & (1ULL << 5))) + (!!(((w) >> 8) & (1ULL << 6))) + (!=
!(((w) >> 8) & (1ULL << 7))) )) + (( (!!(((w) >> 16) & (1ULL << 0))) + (!!(=
((w) >> 16) & (1ULL << 1))) + (!!(((w) >> 16) & (1ULL << 2))) + (!!(((w) >>=
 16) & (1ULL << 3))) + (!!(((w) >> 16) & (1ULL << 4))) + (!!(((w) >> 16) & =
(1ULL << 5))) + (!!(((w) >> 16) & (1ULL << 6))) + (!!(((w) >> 16) & (1ULL <=
< 7))) ) + ( (!!((((w) >> 16) >> 8) & (1ULL << 0))) + (!!((((w) >> 16) >> 8=
) & (1ULL << 1))) + (!!((((w) >> 16) >> 8) & (1ULL << 2))) + (!!((((w) >> 1=
6) >> 8) & (1ULL << 3))) + (!!((((w) >> 16) >> 8) & (1ULL << 4))) + (!!((((=
w) >> 16) >> 8) & (1ULL << 5))) + (!!((((w) >> 16) >> 8) & (1ULL << 6))) + =
(!!((((w) >> 16) >> 8) & (1ULL << 7))) ))) + ((( (!!(((w) >> 32) & (1ULL <<=
 0))) + (!!(((w) >> 32) & (1ULL << 1))) + (!!(((w) >> 32) & (1ULL << 2))) +=
 (!!(((w) >> 32) & (1ULL << 3))) + (!!(((w) >> 32) & (1ULL << 4))) + (!!(((=
w) >> 32) & (1ULL << 5))) + (!!(((w) >> 32) & (1ULL << 6))) + (!!(((w) >> 3=
2) & (1ULL << 7))) ) + ( (!!((((w) >> 32) >> 8) & (1ULL << 0))) + (!!((((w)=
 >> 32) >> 8) & (1ULL << 1))) + (!!((((w) >> 32) >> 8) & (1ULL << 2))) + (!=
!((((w) >> 32) >> 8) & (1ULL << 3))) + (!!((((w) >> 32) >> 8) & (1ULL << 4)=
)) + (!!((((w) >> 32) >> 8) & (1ULL << 5))) + (!!((((w) >> 32) >> 8) & (1UL=
L << 6))) + (!!((((w) >> 32) >> 8) & (1ULL << 7))) )) + (( (!!((((w) >> 32)=
 >> 16) & (1ULL << 0))) + (!!((((w) >> 32) >> 16) & (1ULL << 1))) + (!!((((=
w) >> 32) >> 16) & (1ULL << 2))) + (!!((((w) >> 32) >> 16) & (1ULL << 3))) =
+ (!!((((w) >> 32) >> 16) & (1ULL << 4))) + (!!((((w) >> 32) >> 16) & (1ULL=
 << 5))) + (!!((((w) >> 32) >> 16) & (1ULL << 6))) + (!!((((w) >> 32) >> 16=
) & (1ULL << 7))) ) + ( (!!(((((w) >> 32) >> 16) >> 8) & (1ULL << 0))) + (!=
!(((((w) >> 32) >> 16) >> 8) & (1ULL << 1))) + (!!(((((w) >> 32) >> 16) >> =
8) & (1ULL << 2))) + (!!(((((w) >> 32) >> 16) >> 8) & (1ULL << 3))) + (!!((=
(((w) >> 32) >> 16) >> 8) & (1ULL << 4))) + (!!(((((w) >> 32) >> 16) >> 8) =
& (1ULL << 5))) + (!!(((((w) >> 32) >> 16) >> 8) & (1ULL << 6))) + (!!(((((=
w) >> 32) >> 16) >> 8) & (1ULL << 7))) )))) : __arch_hweight64(w));
}






static inline __attribute__((no_instrument_function)) __u64 rol64(__u64 wor=
d, unsigned int shift)
{
 return (word << shift) | (word >> (64 - shift));
}






static inline __attribute__((no_instrument_function)) __u64 ror64(__u64 wor=
d, unsigned int shift)
{
 return (word >> shift) | (word << (64 - shift));
}






static inline __attribute__((no_instrument_function)) __u32 rol32(__u32 wor=
d, unsigned int shift)
{
 return (word << shift) | (word >> (32 - shift));
}






static inline __attribute__((no_instrument_function)) __u32 ror32(__u32 wor=
d, unsigned int shift)
{
 return (word >> shift) | (word << (32 - shift));
}






static inline __attribute__((no_instrument_function)) __u16 rol16(__u16 wor=
d, unsigned int shift)
{
 return (word << shift) | (word >> (16 - shift));
}






static inline __attribute__((no_instrument_function)) __u16 ror16(__u16 wor=
d, unsigned int shift)
{
 return (word >> shift) | (word << (16 - shift));
}






static inline __attribute__((no_instrument_function)) __u8 rol8(__u8 word, =
unsigned int shift)
{
 return (word << shift) | (word >> (8 - shift));
}






static inline __attribute__((no_instrument_function)) __u8 ror8(__u8 word, =
unsigned int shift)
{
 return (word >> shift) | (word << (8 - shift));
}






static inline __attribute__((no_instrument_function)) __s32 sign_extend32(_=
_u32 value, int index)
{
 __u8 shift =3D 31 - index;
 return (__s32)(value << shift) >> shift;
}

static inline __attribute__((no_instrument_function)) unsigned fls_long(uns=
igned long l)
{
 if (sizeof(l) =3D=3D 4)
  return fls(l);
 return fls64(l);
}
# 175 "/usr/src/linux-2.6/include/linux/bitops.h"
static inline __attribute__((no_instrument_function)) unsigned long __ffs64=
(u64 word)
{

 if (((u32)word) =3D=3D 0UL)
  return __ffs((u32)(word >> 32)) + 32;



 return __ffs((unsigned long)word);
}
# 196 "/usr/src/linux-2.6/include/linux/bitops.h"
extern unsigned long find_last_bit(const unsigned long *addr,
       unsigned long size);
# 11 "/usr/src/linux-2.6/include/linux/kernel.h" 2
# 1 "/usr/src/linux-2.6/include/linux/log2.h" 1
# 21 "/usr/src/linux-2.6/include/linux/log2.h"
extern __attribute__((const, noreturn))
int ____ilog2_NaN(void);
# 31 "/usr/src/linux-2.6/include/linux/log2.h"
static inline __attribute__((no_instrument_function)) __attribute__((const))
int __ilog2_u32(u32 n)
{
 return fls(n) - 1;
}



static inline __attribute__((no_instrument_function)) __attribute__((const))
int __ilog2_u64(u64 n)
{
 return fls64(n) - 1;
}







static inline __attribute__((no_instrument_function)) __attribute__((const))
bool is_power_of_2(unsigned long n)
{
 return (n !=3D 0 && ((n & (n - 1)) =3D=3D 0));
}




static inline __attribute__((no_instrument_function)) __attribute__((const))
unsigned long __roundup_pow_of_two(unsigned long n)
{
 return 1UL << fls_long(n - 1);
}




static inline __attribute__((no_instrument_function)) __attribute__((const))
unsigned long __rounddown_pow_of_two(unsigned long n)
{
 return 1UL << (fls_long(n) - 1);
}
# 12 "/usr/src/linux-2.6/include/linux/kernel.h" 2

# 1 "/usr/src/linux-2.6/include/linux/printk.h" 1





# 1 "/usr/src/linux-2.6/include/linux/kern_levels.h" 1
# 7 "/usr/src/linux-2.6/include/linux/printk.h" 2


extern const char linux_banner[];
extern const char linux_proc_banner[];

static inline __attribute__((no_instrument_function)) int printk_get_level(=
const char *buffer)
{
 if (buffer[0] =3D=3D '\001' && buffer[1]) {
  switch (buffer[1]) {
  case '0' ... '7':
  case 'd':
   return buffer[1];
  }
 }
 return 0;
}

static inline __attribute__((no_instrument_function)) const char *printk_sk=
ip_level(const char *buffer)
{
 if (printk_get_level(buffer)) {
  switch (buffer[1]) {
  case '0' ... '7':
  case 'd':
   return buffer + 2;
  }
 }
 return buffer;
}

extern int console_printk[];






static inline __attribute__((no_instrument_function)) void console_silent(v=
oid)
{
 (console_printk[0]) =3D 0;
}

static inline __attribute__((no_instrument_function)) void console_verbose(=
void)
{
 if ((console_printk[0]))
  (console_printk[0]) =3D 15;
}

struct va_format {
 const char *fmt;
 va_list *va;
};
# 94 "/usr/src/linux-2.6/include/linux/printk.h"
static inline __attribute__((no_instrument_function)) __attribute__((format=
(printf, 1, 2)))
int no_printk(const char *fmt, ...)
{
 return 0;
}


extern __attribute__((regparm(0))) __attribute__((format(printf, 1, 2)))
void early_printk(const char *fmt, ...);
void early_vprintk(const char *fmt, va_list ap);






 __attribute__((regparm(0))) __attribute__((format(printf, 5, 0)))
int vprintk_emit(int facility, int level,
   const char *dict, size_t dictlen,
   const char *fmt, va_list args);

 __attribute__((regparm(0))) __attribute__((format(printf, 1, 0)))
int vprintk(const char *fmt, va_list args);

 __attribute__((regparm(0))) __attribute__((format(printf, 5, 6))) __attrib=
ute__((__cold__))
 __attribute__((regparm(0))) int printk_emit(int facility, int level,
      const char *dict, size_t dictlen,
      const char *fmt, ...);

 __attribute__((regparm(0))) __attribute__((format(printf, 1, 2))) __attrib=
ute__((__cold__))
int printk(const char *fmt, ...);




__attribute__((format(printf, 1, 2))) __attribute__((__cold__)) int printk_=
sched(const char *fmt, ...);






extern int __printk_ratelimit(const char *func);

extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
       unsigned int interval_msec);

extern int printk_delay_msec;
extern int dmesg_restrict;
extern int kptr_restrict;

extern void wake_up_klogd(void);

void log_buf_kexec_setup(void);
void __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) =
__attribute__((no_instrument_function)) setup_log_buf(int early);
void dump_stack_set_arch_desc(const char *fmt, ...);
void dump_stack_print_info(const char *log_lvl);
void show_regs_print_info(const char *log_lvl);
# 203 "/usr/src/linux-2.6/include/linux/printk.h"
extern __attribute__((regparm(0))) void dump_stack(void) __attribute__((__c=
old__));
# 354 "/usr/src/linux-2.6/include/linux/printk.h"
extern const struct file_operations kmsg_fops;

enum {
 DUMP_PREFIX_NONE,
 DUMP_PREFIX_ADDRESS,
 DUMP_PREFIX_OFFSET
};
extern void hex_dump_to_buffer(const void *buf, size_t len,
          int rowsize, int groupsize,
          char *linebuf, size_t linebuflen, bool ascii);

extern void print_hex_dump(const char *level, const char *prefix_str,
      int prefix_type, int rowsize, int groupsize,
      const void *buf, size_t len, bool ascii);




extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
     const void *buf, size_t len);
# 14 "/usr/src/linux-2.6/include/linux/kernel.h" 2
# 1 "/usr/src/linux-2.6/include/linux/dynamic_debug.h" 1
# 9 "/usr/src/linux-2.6/include/linux/dynamic_debug.h"
struct _ddebug {




 const char *modname;
 const char *function;
 const char *filename;
 const char *format;
 unsigned int lineno:18;
# 35 "/usr/src/linux-2.6/include/linux/dynamic_debug.h"
 unsigned int flags:8;
} __attribute__((aligned(8)));


int ddebug_add_module(struct _ddebug *tab, unsigned int n,
    const char *modname);
# 111 "/usr/src/linux-2.6/include/linux/dynamic_debug.h"
# 1 "/usr/src/linux-2.6/include/linux/string.h" 1
# 9 "/usr/src/linux-2.6/include/linux/string.h"
# 1 "/usr/src/linux-2.6/include/uapi/linux/string.h" 1
# 10 "/usr/src/linux-2.6/include/linux/string.h" 2

extern char *strndup_user(const char *, long);
extern void *memdup_user(const void *, size_t);




# 1 "/usr/src/linux-2.6/arch/x86/include/asm/string.h" 1

# 1 "/usr/src/linux-2.6/arch/x86/include/asm/string_32.h" 1
# 9 "/usr/src/linux-2.6/arch/x86/include/asm/string_32.h"
extern char *strcpy(char *dest, const char *src);


extern char *strncpy(char *dest, const char *src, size_t count);


extern char *strcat(char *dest, const char *src);


extern char *strncat(char *dest, const char *src, size_t count);


extern int strcmp(const char *cs, const char *ct);


extern int strncmp(const char *cs, const char *ct, size_t count);


extern char *strchr(const char *s, int c);


extern size_t strlen(const char *s);

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *__memcpy(void *to, const void *from, size_t n)
{
 int d0, d1, d2;
 asm volatile("rep ; movsl\n\t"
       "movl %4,%%ecx\n\t"
       "andl $3,%%ecx\n\t"
       "jz 1f\n\t"
       "rep ; movsb\n\t"
       "1:"
       : "=3D&c" (d0), "=3D&D" (d1), "=3D&S" (d2)
       : "0" (n / 4), "g" (n), "1" ((long)to), "2" ((long)from)
       : "memory");
 return to;
}





static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *__constant_memcpy(void *to, const void *from,
            size_t n)
{
 long esi, edi;
 if (!n)
  return to;

 switch (n) {
 case 1:
  *(char *)to =3D *(char *)from;
  return to;
 case 2:
  *(short *)to =3D *(short *)from;
  return to;
 case 4:
  *(int *)to =3D *(int *)from;
  return to;
 case 3:
  *(short *)to =3D *(short *)from;
  *((char *)to + 2) =3D *((char *)from + 2);
  return to;
 case 5:
  *(int *)to =3D *(int *)from;
  *((char *)to + 4) =3D *((char *)from + 4);
  return to;
 case 6:
  *(int *)to =3D *(int *)from;
  *((short *)to + 2) =3D *((short *)from + 2);
  return to;
 case 8:
  *(int *)to =3D *(int *)from;
  *((int *)to + 1) =3D *((int *)from + 1);
  return to;
 }

 esi =3D (long)from;
 edi =3D (long)to;
 if (n >=3D 5 * 4) {

  int ecx;
  asm volatile("rep ; movsl"
        : "=3D&c" (ecx), "=3D&D" (edi), "=3D&S" (esi)
        : "0" (n / 4), "1" (edi), "2" (esi)
        : "memory"
  );
 } else {

  if (n >=3D 4 * 4)
   asm volatile("movsl"
         : "=3D&D"(edi), "=3D&S"(esi)
         : "0"(edi), "1"(esi)
         : "memory");
  if (n >=3D 3 * 4)
   asm volatile("movsl"
         : "=3D&D"(edi), "=3D&S"(esi)
         : "0"(edi), "1"(esi)
         : "memory");
  if (n >=3D 2 * 4)
   asm volatile("movsl"
         : "=3D&D"(edi), "=3D&S"(esi)
         : "0"(edi), "1"(esi)
         : "memory");
  if (n >=3D 1 * 4)
   asm volatile("movsl"
         : "=3D&D"(edi), "=3D&S"(esi)
         : "0"(edi), "1"(esi)
         : "memory");
 }
 switch (n % 4) {

 case 0:
  return to;
 case 1:
  asm volatile("movsb"
        : "=3D&D"(edi), "=3D&S"(esi)
        : "0"(edi), "1"(esi)
        : "memory");
  return to;
 case 2:
  asm volatile("movsw"
        : "=3D&D"(edi), "=3D&S"(esi)
        : "0"(edi), "1"(esi)
        : "memory");
  return to;
 default:
  asm volatile("movsw\n\tmovsb"
        : "=3D&D"(edi), "=3D&S"(esi)
        : "0"(edi), "1"(esi)
        : "memory");
  return to;
 }
}
# 200 "/usr/src/linux-2.6/arch/x86/include/asm/string_32.h"
void *memmove(void *dest, const void *src, size_t n);




extern void *memchr(const void *cs, int c, size_t count);

static inline __attribute__((no_instrument_function)) void *__memset_generi=
c(void *s, char c, size_t count)
{
 int d0, d1;
 asm volatile("rep\n\t"
       "stosb"
       : "=3D&c" (d0), "=3D&D" (d1)
       : "a" (c), "1" (s), "0" (count)
       : "memory");
 return s;
}
# 226 "/usr/src/linux-2.6/arch/x86/include/asm/string_32.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline))
void *__constant_c_memset(void *s, unsigned long c, size_t count)
{
 int d0, d1;
 asm volatile("rep ; stosl\n\t"
       "testb $2,%b3\n\t"
       "je 1f\n\t"
       "stosw\n"
       "1:\ttestb $1,%b3\n\t"
       "je 2f\n\t"
       "stosb\n"
       "2:"
       : "=3D&c" (d0), "=3D&D" (d1)
       : "a" (c), "q" (count), "0" (count/4), "1" ((long)s)
       : "memory");
 return s;
}



extern size_t strnlen(const char *s, size_t count);



extern char *strstr(const char *cs, const char *ct);





static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline))
void *__constant_c_and_count_memset(void *s, unsigned long pattern,
        size_t count)
{
 switch (count) {
 case 0:
  return s;
 case 1:
  *(unsigned char *)s =3D pattern & 0xff;
  return s;
 case 2:
  *(unsigned short *)s =3D pattern & 0xffff;
  return s;
 case 3:
  *(unsigned short *)s =3D pattern & 0xffff;
  *((unsigned char *)s + 2) =3D pattern & 0xff;
  return s;
 case 4:
  *(unsigned long *)s =3D pattern;
  return s;
 }
# 285 "/usr/src/linux-2.6/arch/x86/include/asm/string_32.h"
 {
  int d0, d1;




  unsigned long eax =3D pattern;


  switch (count % 4) {
  case 0:
   asm volatile("rep ; stosl" "" : "=3D&c" (d0), "=3D&D" (d1) : "a" (eax), =
"0" (count/4), "1" ((long)s) : "memory");
   return s;
  case 1:
   asm volatile("rep ; stosl" "\n\tstosb" : "=3D&c" (d0), "=3D&D" (d1) : "a=
" (eax), "0" (count/4), "1" ((long)s) : "memory");
   return s;
  case 2:
   asm volatile("rep ; stosl" "\n\tstosw" : "=3D&c" (d0), "=3D&D" (d1) : "a=
" (eax), "0" (count/4), "1" ((long)s) : "memory");
   return s;
  default:
   asm volatile("rep ; stosl" "\n\tstosw\n\tstosb" : "=3D&c" (d0), "=3D&D" =
(d1) : "a" (eax), "0" (count/4), "1" ((long)s) : "memory");
   return s;
  }
 }


}
# 338 "/usr/src/linux-2.6/arch/x86/include/asm/string_32.h"
extern void *memscan(void *addr, int c, size_t size);
# 3 "/usr/src/linux-2.6/arch/x86/include/asm/string.h" 2
# 18 "/usr/src/linux-2.6/include/linux/string.h" 2
# 26 "/usr/src/linux-2.6/include/linux/string.h"
size_t strlcpy(char *, const char *, size_t);
# 35 "/usr/src/linux-2.6/include/linux/string.h"
extern size_t strlcat(char *, const char *, __kernel_size_t);
# 44 "/usr/src/linux-2.6/include/linux/string.h"
extern int strnicmp(const char *, const char *, __kernel_size_t);


extern int strcasecmp(const char *s1, const char *s2);


extern int strncasecmp(const char *s1, const char *s2, size_t n);





extern char * strnchr(const char *, size_t, int);


extern char * strrchr(const char *,int);

extern char * __attribute__((warn_unused_result)) skip_spaces(const char *);

extern char *strim(char *);

static inline __attribute__((no_instrument_function)) __attribute__((warn_u=
nused_result)) char *strstrip(char *str)
{
 return strim(str);
}





extern char * strnstr(const char *, const char *, size_t);
# 83 "/usr/src/linux-2.6/include/linux/string.h"
extern char * strpbrk(const char *,const char *);


extern char * strsep(char **,const char *);


extern __kernel_size_t strspn(const char *,const char *);


extern __kernel_size_t strcspn(const char *,const char *);
# 108 "/usr/src/linux-2.6/include/linux/string.h"
extern int __builtin_memcmp(const void *,const void *,__kernel_size_t);




void *memchr_inv(const void *s, int c, size_t n);

extern char *kstrdup(const char *s, gfp_t gfp);
extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
extern void *kmemdup(const void *src, size_t len, gfp_t gfp);

extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
extern void argv_free(char **argv);

extern bool sysfs_streq(const char *s1, const char *s2);
extern int strtobool(const char *s, bool *res);


int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf=
);
int bprintf(u32 *bin_buf, size_t size, const char *fmt, ...) __attribute__(=
(format(printf, 3, 4)));


extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
   const void *from, size_t available);






static inline __attribute__((no_instrument_function)) bool strstarts(const =
char *str, const char *prefix)
{
 return strncmp(str, prefix, strlen(prefix)) =3D=3D 0;
}

extern size_t memweight(const void *ptr, size_t bytes);






static inline __attribute__((no_instrument_function)) const char *kbasename=
(const char *path)
{
 const char *tail =3D strrchr(path, '/');
 return tail ? tail + 1 : path;
}
# 112 "/usr/src/linux-2.6/include/linux/dynamic_debug.h" 2
# 1 "/usr/src/linux-2.6/include/linux/errno.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/errno.h" 1
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/errno.h" 1
# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/errno.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/errno-base.h" 1
# 5 "/usr/src/linux-2.6/include/uapi/asm-generic/errno.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/errno.h" 2
# 1 "/usr/src/linux-2.6/include/uapi/linux/errno.h" 2
# 5 "/usr/src/linux-2.6/include/linux/errno.h" 2
# 113 "/usr/src/linux-2.6/include/linux/dynamic_debug.h" 2

static inline __attribute__((no_instrument_function)) int ddebug_remove_mod=
ule(const char *mod)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int ddebug_dyndbg_mod=
ule_param_cb(char *param, char *val,
      const char *modname)
{
 if (strstr(param, "dyndbg")) {

  printk("\001" "4" "dyndbg param is supported only in "
   "CONFIG_DYNAMIC_DEBUG builds\n");
  return 0;
 }
 return -22;
}
# 15 "/usr/src/linux-2.6/include/linux/kernel.h" 2

# 1 "/usr/src/linux-2.6/include/uapi/linux/kernel.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/sysinfo.h" 1






struct sysinfo {
 __kernel_long_t uptime;
 __kernel_ulong_t loads[3];
 __kernel_ulong_t totalram;
 __kernel_ulong_t freeram;
 __kernel_ulong_t sharedram;
 __kernel_ulong_t bufferram;
 __kernel_ulong_t totalswap;
 __kernel_ulong_t freeswap;
 __u16 procs;
 __u16 pad;
 __kernel_ulong_t totalhigh;
 __kernel_ulong_t freehigh;
 __u32 mem_unit;
 char _f[20-2*sizeof(__kernel_ulong_t)-sizeof(__u32)];
};
# 5 "/usr/src/linux-2.6/include/uapi/linux/kernel.h" 2
# 17 "/usr/src/linux-2.6/include/linux/kernel.h" 2
# 111 "/usr/src/linux-2.6/include/linux/kernel.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/div64.h" 1
# 42 "/usr/src/linux-2.6/arch/x86/include/asm/div64.h"
static inline __attribute__((no_instrument_function)) u64 div_u64_rem(u64 d=
ividend, u32 divisor, u32 *remainder)
{
 union {
  u64 v64;
  u32 v32[2];
 } d =3D { dividend };
 u32 upper;

 upper =3D d.v32[1];
 d.v32[1] =3D 0;
 if (upper >=3D divisor) {
  d.v32[1] =3D upper / divisor;
  upper %=3D divisor;
 }
 asm ("divl %2" : "=3Da" (d.v32[0]), "=3Dd" (*remainder) :
  "rm" (divisor), "0" (d.v32[0]), "1" (upper));
 return d.v64;
}
# 112 "/usr/src/linux-2.6/include/linux/kernel.h" 2
# 140 "/usr/src/linux-2.6/include/linux/kernel.h"
struct completion;
struct pt_regs;
struct user;


extern int _cond_resched(void);
# 166 "/usr/src/linux-2.6/include/linux/kernel.h"
  static inline __attribute__((no_instrument_function)) void __might_sleep(=
const char *file, int line,
       int preempt_offset) { }
# 199 "/usr/src/linux-2.6/include/linux/kernel.h"
static inline __attribute__((no_instrument_function)) void might_fault(void=
) { }


extern struct atomic_notifier_head panic_notifier_list;
extern long (*panic_blink)(int state);
__attribute__((format(printf, 1, 2)))
void panic(const char *fmt, ...)
 __attribute__((noreturn)) __attribute__((__cold__));
extern void oops_enter(void);
extern void oops_exit(void);
void print_oops_end_marker(void);
extern int oops_may_print(void);
void do_exit(long error_code)
 __attribute__((noreturn));
void complete_and_exit(struct completion *, long)
 __attribute__((noreturn));


int __attribute__((warn_unused_result)) _kstrtoul(const char *s, unsigned i=
nt base, unsigned long *res);
int __attribute__((warn_unused_result)) _kstrtol(const char *s, unsigned in=
t base, long *res);

int __attribute__((warn_unused_result)) kstrtoull(const char *s, unsigned i=
nt base, unsigned long long *res);
int __attribute__((warn_unused_result)) kstrtoll(const char *s, unsigned in=
t base, long long *res);
# 239 "/usr/src/linux-2.6/include/linux/kernel.h"
static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtoul(const char *s, unsigned int base, unsigned long=
 *res)
{




 if (sizeof(unsigned long) =3D=3D sizeof(unsigned long long) &&
     __alignof__(unsigned long) =3D=3D __alignof__(unsigned long long))
  return kstrtoull(s, base, (unsigned long long *)res);
 else
  return _kstrtoul(s, base, res);
}
# 268 "/usr/src/linux-2.6/include/linux/kernel.h"
static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtol(const char *s, unsigned int base, long *res)
{




 if (sizeof(long) =3D=3D sizeof(long long) &&
     __alignof__(long) =3D=3D __alignof__(long long))
  return kstrtoll(s, base, (long long *)res);
 else
  return _kstrtol(s, base, res);
}

int __attribute__((warn_unused_result)) kstrtouint(const char *s, unsigned =
int base, unsigned int *res);
int __attribute__((warn_unused_result)) kstrtoint(const char *s, unsigned i=
nt base, int *res);

static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtou64(const char *s, unsigned int base, u64 *res)
{
 return kstrtoull(s, base, res);
}

static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtos64(const char *s, unsigned int base, s64 *res)
{
 return kstrtoll(s, base, res);
}

static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtou32(const char *s, unsigned int base, u32 *res)
{
 return kstrtouint(s, base, res);
}

static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtos32(const char *s, unsigned int base, s32 *res)
{
 return kstrtoint(s, base, res);
}

int __attribute__((warn_unused_result)) kstrtou16(const char *s, unsigned i=
nt base, u16 *res);
int __attribute__((warn_unused_result)) kstrtos16(const char *s, unsigned i=
nt base, s16 *res);
int __attribute__((warn_unused_result)) kstrtou8(const char *s, unsigned in=
t base, u8 *res);
int __attribute__((warn_unused_result)) kstrtos8(const char *s, unsigned in=
t base, s8 *res);

int __attribute__((warn_unused_result)) kstrtoull_from_user(const char *s, =
size_t count, unsigned int base, unsigned long long *res);
int __attribute__((warn_unused_result)) kstrtoll_from_user(const char *s, s=
ize_t count, unsigned int base, long long *res);
int __attribute__((warn_unused_result)) kstrtoul_from_user(const char *s, s=
ize_t count, unsigned int base, unsigned long *res);
int __attribute__((warn_unused_result)) kstrtol_from_user(const char *s, si=
ze_t count, unsigned int base, long *res);
int __attribute__((warn_unused_result)) kstrtouint_from_user(const char *s,=
 size_t count, unsigned int base, unsigned int *res);
int __attribute__((warn_unused_result)) kstrtoint_from_user(const char *s, =
size_t count, unsigned int base, int *res);
int __attribute__((warn_unused_result)) kstrtou16_from_user(const char *s, =
size_t count, unsigned int base, u16 *res);
int __attribute__((warn_unused_result)) kstrtos16_from_user(const char *s, =
size_t count, unsigned int base, s16 *res);
int __attribute__((warn_unused_result)) kstrtou8_from_user(const char *s, s=
ize_t count, unsigned int base, u8 *res);
int __attribute__((warn_unused_result)) kstrtos8_from_user(const char *s, s=
ize_t count, unsigned int base, s8 *res);

static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtou64_from_user(const char *s, size_t count, unsigne=
d int base, u64 *res)
{
 return kstrtoull_from_user(s, count, base, res);
}

static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtos64_from_user(const char *s, size_t count, unsigne=
d int base, s64 *res)
{
 return kstrtoll_from_user(s, count, base, res);
}

static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtou32_from_user(const char *s, size_t count, unsigne=
d int base, u32 *res)
{
 return kstrtouint_from_user(s, count, base, res);
}

static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kstrtos32_from_user(const char *s, size_t count, unsigne=
d int base, s32 *res)
{
 return kstrtoint_from_user(s, count, base, res);
}



extern unsigned long simple_strtoul(const char *,char **,unsigned int);
extern long simple_strtol(const char *,char **,unsigned int);
extern unsigned long long simple_strtoull(const char *,char **,unsigned int=
);
extern long long simple_strtoll(const char *,char **,unsigned int);





extern int num_to_str(char *buf, int size, unsigned long long num);



extern __attribute__((format(printf, 2, 3))) int sprintf(char *buf, const c=
har * fmt, ...);
extern __attribute__((format(printf, 2, 0))) int vsprintf(char *buf, const =
char *, va_list);
extern __attribute__((format(printf, 3, 4)))
int snprintf(char *buf, size_t size, const char *fmt, ...);
extern __attribute__((format(printf, 3, 0)))
int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
extern __attribute__((format(printf, 3, 4)))
int scnprintf(char *buf, size_t size, const char *fmt, ...);
extern __attribute__((format(printf, 3, 0)))
int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
extern __attribute__((format(printf, 2, 3)))
char *kasprintf(gfp_t gfp, const char *fmt, ...);
extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);

extern __attribute__((format(scanf, 2, 3)))
int sscanf(const char *, const char *, ...);
extern __attribute__((format(scanf, 2, 0)))
int vsscanf(const char *, const char *, va_list);

extern int get_option(char **str, int *pint);
extern char *get_options(const char *str, int nints, int *ints);
extern unsigned long long memparse(const char *ptr, char **retptr);

extern int core_kernel_text(unsigned long addr);
extern int core_kernel_data(unsigned long addr);
extern int __kernel_text_address(unsigned long addr);
extern int kernel_text_address(unsigned long addr);
extern int func_ptr_is_kernel_text(void *ptr);

struct pid;
extern struct pid *session_of_pgrp(struct pid *pgrp);

unsigned long int_sqrt(unsigned long);

extern void bust_spinlocks(int yes);
extern int oops_in_progress;
extern int panic_timeout;
extern int panic_on_oops;
extern int panic_on_unrecovered_nmi;
extern int panic_on_io_nmi;
extern int sysctl_panic_on_stackoverflow;
extern const char *print_tainted(void);
enum lockdep_ok {
 LOCKDEP_STILL_OK,
 LOCKDEP_NOW_UNRELIABLE
};
extern void add_taint(unsigned flag, enum lockdep_ok);
extern int test_taint(unsigned flag);
extern unsigned long get_taint(void);
extern int root_mountflags;

extern bool early_boot_irqs_disabled;


extern enum system_states {
 SYSTEM_BOOTING,
 SYSTEM_RUNNING,
 SYSTEM_HALT,
 SYSTEM_POWER_OFF,
 SYSTEM_RESTART,
} system_state;
# 431 "/usr/src/linux-2.6/include/linux/kernel.h"
extern const char hex_asc[];



static inline __attribute__((no_instrument_function)) char *hex_byte_pack(c=
har *buf, u8 byte)
{
 *buf++ =3D hex_asc[((byte) & 0xf0) >> 4];
 *buf++ =3D hex_asc[((byte) & 0x0f)];
 return buf;
}

extern const char hex_asc_upper[];



static inline __attribute__((no_instrument_function)) char *hex_byte_pack_u=
pper(char *buf, u8 byte)
{
 *buf++ =3D hex_asc_upper[((byte) & 0xf0) >> 4];
 *buf++ =3D hex_asc_upper[((byte) & 0x0f)];
 return buf;
}

static inline __attribute__((no_instrument_function)) char * pack_hex_byte(=
char *buf, u8 byte)
{
 return hex_byte_pack(buf, byte);
}

extern int hex_to_bin(char ch);
extern int __attribute__((warn_unused_result)) hex2bin(u8 *dst, const char =
*src, size_t count);

int mac_pton(const char *s, u8 *mac);
# 484 "/usr/src/linux-2.6/include/linux/kernel.h"
void tracing_off_permanent(void);




enum ftrace_dump_mode {
 DUMP_NONE,
 DUMP_ALL,
 DUMP_ORIG,
};


void tracing_on(void);
void tracing_off(void);
int tracing_is_on(void);
void tracing_snapshot(void);
void tracing_snapshot_alloc(void);

extern void tracing_start(void);
extern void tracing_stop(void);
extern void ftrace_off_permanent(void);

static inline __attribute__((no_instrument_function)) __attribute__((format=
(printf, 1, 2)))
void ____trace_printk_check_format(const char *fmt, ...)
{
}
# 569 "/usr/src/linux-2.6/include/linux/kernel.h"
extern __attribute__((format(printf, 2, 3)))
int __trace_bprintk(unsigned long ip, const char *fmt, ...);

extern __attribute__((format(printf, 2, 3)))
int __trace_printk(unsigned long ip, const char *fmt, ...);
# 610 "/usr/src/linux-2.6/include/linux/kernel.h"
extern int __trace_bputs(unsigned long ip, const char *str);
extern int __trace_puts(unsigned long ip, const char *str, int size);

extern void trace_dump_stack(int skip);
# 632 "/usr/src/linux-2.6/include/linux/kernel.h"
extern int
__ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap);

extern int
__ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);

extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
# 45 "/usr/src/linux-2.6/arch/x86/include/asm/percpu.h" 2
# 88 "/usr/src/linux-2.6/arch/x86/include/asm/percpu.h"
extern void __bad_percpu_size(void);
# 499 "/usr/src/linux-2.6/arch/x86/include/asm/percpu.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) int x86_this_cpu_constant_test_bit(unsigned int nr,
                        const unsigned long *addr)
{
 unsigned long *a =3D (unsigned long *)addr + nr / 32;




 return ((1UL << (nr % 32)) & ({ typeof((*a)) pfo_ret__; switch (sizeof((*a=
))) { case 1: asm("mov" "b """ "%P" "1"",%0" : "=3Dq" (pfo_ret__) : "m"(*a)=
); break; case 2: asm("mov" "w """ "%P" "1"",%0" : "=3Dr" (pfo_ret__) : "m"=
(*a)); break; case 4: asm("mov" "l """ "%P" "1"",%0" : "=3Dr" (pfo_ret__) :=
 "m"(*a)); break; case 8: asm("mov" "q """ "%P" "1"",%0" : "=3Dr" (pfo_ret_=
_) : "m"(*a)); break; default: __bad_percpu_size(); } pfo_ret__; })) !=3D 0;

}

static inline __attribute__((no_instrument_function)) int x86_this_cpu_vari=
able_test_bit(int nr,
                        const unsigned long *addr)
{
 int oldbit;

 asm volatile("bt """ "%P" "2"",%1\n\t"
   "sbb %0,%0"
   : "=3Dr" (oldbit)
   : "m" (*(unsigned long *)addr), "Ir" (nr));

 return oldbit;
}







# 1 "/usr/src/linux-2.6/include/asm-generic/percpu.h" 1




# 1 "/usr/src/linux-2.6/include/linux/threads.h" 1
# 6 "/usr/src/linux-2.6/include/asm-generic/percpu.h" 2
# 1 "/usr/src/linux-2.6/include/linux/percpu-defs.h" 1
# 7 "/usr/src/linux-2.6/include/asm-generic/percpu.h" 2
# 531 "/usr/src/linux-2.6/arch/x86/include/asm/percpu.h" 2


extern __attribute__((section(".data" ""))) __typeof__(unsigned long) this_=
cpu_off;
# 6 "/usr/src/linux-2.6/arch/x86/include/asm/preempt.h" 2
# 1 "/usr/src/linux-2.6/include/linux/thread_info.h" 1
# 11 "/usr/src/linux-2.6/include/linux/thread_info.h"
# 1 "/usr/src/linux-2.6/include/linux/bug.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/asm/bug.h" 1
# 38 "/usr/src/linux-2.6/arch/x86/include/asm/bug.h"
# 1 "/usr/src/linux-2.6/include/asm-generic/bug.h" 1
# 18 "/usr/src/linux-2.6/include/asm-generic/bug.h"
struct bug_entry {

 unsigned long bug_addr;





 const char *file;



 unsigned short line;

 unsigned short flags;
};
# 65 "/usr/src/linux-2.6/include/asm-generic/bug.h"
extern __attribute__((format(printf, 3, 4)))
void warn_slowpath_fmt(const char *file, const int line,
         const char *fmt, ...);
extern __attribute__((format(printf, 4, 5)))
void warn_slowpath_fmt_taint(const char *file, const int line, unsigned tai=
nt,
        const char *fmt, ...);
extern void warn_slowpath_null(const char *file, const int line);
# 39 "/usr/src/linux-2.6/arch/x86/include/asm/bug.h" 2
# 5 "/usr/src/linux-2.6/include/linux/bug.h" 2


enum bug_trap_type {
 BUG_TRAP_TYPE_NONE =3D 0,
 BUG_TRAP_TYPE_WARN =3D 1,
 BUG_TRAP_TYPE_BUG =3D 2,
};

struct pt_regs;
# 91 "/usr/src/linux-2.6/include/linux/bug.h"
static inline __attribute__((no_instrument_function)) int is_warning_bug(co=
nst struct bug_entry *bug)
{
 return bug->flags & (1 << 0);
}

const struct bug_entry *find_bug(unsigned long bugaddr);

enum bug_trap_type report_bug(unsigned long bug_addr, struct pt_regs *regs);


int is_valid_bugaddr(unsigned long addr);
# 12 "/usr/src/linux-2.6/include/linux/thread_info.h" 2

struct timespec;
struct compat_timespec;




struct restart_block {
 long (*fn)(struct restart_block *);
 union {

  struct {
   u32 *uaddr;
   u32 val;
   u32 flags;
   u32 bitset;
   u64 time;
   u32 *uaddr2;
  } futex;

  struct {
   clockid_t clockid;
   struct timespec *rmtp;



   u64 expires;
  } nanosleep;

  struct {
   struct pollfd *ufds;
   int nfds;
   int has_timeout;
   unsigned long tv_sec;
   unsigned long tv_nsec;
  } poll;
 };
};

extern long do_no_restart_syscall(struct restart_block *parm);


# 1 "/usr/src/linux-2.6/arch/x86/include/asm/thread_info.h" 1
# 11 "/usr/src/linux-2.6/arch/x86/include/asm/thread_info.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/page.h" 1
# 13 "/usr/src/linux-2.6/arch/x86/include/asm/page.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/page_32.h" 1
# 40 "/usr/src/linux-2.6/arch/x86/include/asm/page_32.h"
static inline __attribute__((no_instrument_function)) void clear_page(void =
*page)
{
 __builtin_memset(page, 0, ((1UL) << 12));
}

static inline __attribute__((no_instrument_function)) void copy_page(void *=
to, void *from)
{
 __builtin_memcpy(to, from, ((1UL) << 12));
}
# 14 "/usr/src/linux-2.6/arch/x86/include/asm/page.h" 2




struct page;

# 1 "/usr/src/linux-2.6/include/linux/range.h" 1



struct range {
 u64 start;
 u64 end;
};

int add_range(struct range *range, int az, int nr_range,
  u64 start, u64 end);


int add_range_with_merge(struct range *range, int az, int nr_range,
    u64 start, u64 end);

void subtract_range(struct range *range, int az, u64 start, u64 end);

int clean_sort_range(struct range *range, int az);

void sort_range(struct range *range, int nr_range);


static inline __attribute__((no_instrument_function)) resource_size_t cap_r=
esource(u64 val)
{
 if (val > ((resource_size_t)~0))
  return ((resource_size_t)~0);

 return val;
}
# 21 "/usr/src/linux-2.6/arch/x86/include/asm/page.h" 2
extern struct range pfn_mapped[];
extern int nr_pfn_mapped;

static inline __attribute__((no_instrument_function)) void clear_user_page(=
void *page, unsigned long vaddr,
       struct page *pg)
{
 clear_page(page);
}

static inline __attribute__((no_instrument_function)) void copy_user_page(v=
oid *to, void *from, unsigned long vaddr,
      struct page *topage)
{
 copy_page(to, from);
}
# 65 "/usr/src/linux-2.6/arch/x86/include/asm/page.h"
extern bool __virt_addr_valid(unsigned long kaddr);




# 1 "/usr/src/linux-2.6/include/asm-generic/memory_model.h" 1
# 71 "/usr/src/linux-2.6/arch/x86/include/asm/page.h" 2
# 1 "/usr/src/linux-2.6/include/asm-generic/getorder.h" 1
# 12 "/usr/src/linux-2.6/include/asm-generic/getorder.h"
static inline __attribute__((no_instrument_function)) __attribute__((__cons=
t__))
int __get_order(unsigned long size)
{
 int order;

 size--;
 size >>=3D 12;

 order =3D fls(size);



 return order;
}
# 72 "/usr/src/linux-2.6/arch/x86/include/asm/page.h" 2
# 12 "/usr/src/linux-2.6/arch/x86/include/asm/thread_info.h" 2
# 20 "/usr/src/linux-2.6/arch/x86/include/asm/thread_info.h"
struct task_struct;
struct exec_domain;
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 1






struct task_struct;
struct mm_struct;

# 1 "/usr/src/linux-2.6/arch/x86/include/asm/vm86.h" 1





# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/vm86.h" 1
# 62 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/vm86.h"
struct vm86_regs {



 long ebx;
 long ecx;
 long edx;
 long esi;
 long edi;
 long ebp;
 long eax;
 long __null_ds;
 long __null_es;
 long __null_fs;
 long __null_gs;
 long orig_eax;
 long eip;
 unsigned short cs, __csh;
 long eflags;
 long esp;
 unsigned short ss, __ssh;



 unsigned short es, __esh;
 unsigned short ds, __dsh;
 unsigned short fs, __fsh;
 unsigned short gs, __gsh;
};

struct revectored_struct {
 unsigned long __map[8];
};

struct vm86_struct {
 struct vm86_regs regs;
 unsigned long flags;
 unsigned long screen_bitmap;
 unsigned long cpu_type;
 struct revectored_struct int_revectored;
 struct revectored_struct int21_revectored;
};






struct vm86plus_info_struct {
 unsigned long force_return_for_pic:1;
 unsigned long vm86dbg_active:1;
 unsigned long vm86dbg_TFpendig:1;
 unsigned long unused:28;
 unsigned long is_vm86pus:1;
 unsigned char vm86dbg_intxxtab[32];
};
struct vm86plus_struct {
 struct vm86_regs regs;
 unsigned long flags;
 unsigned long screen_bitmap;
 unsigned long cpu_type;
 struct revectored_struct int_revectored;
 struct revectored_struct int21_revectored;
 struct vm86plus_info_struct vm86plus;
};
# 7 "/usr/src/linux-2.6/arch/x86/include/asm/vm86.h" 2
# 17 "/usr/src/linux-2.6/arch/x86/include/asm/vm86.h"
struct kernel_vm86_regs {



 struct pt_regs pt;



 unsigned short es, __esh;
 unsigned short ds, __dsh;
 unsigned short fs, __fsh;
 unsigned short gs, __gsh;
};

struct kernel_vm86_struct {
 struct kernel_vm86_regs regs;
# 42 "/usr/src/linux-2.6/arch/x86/include/asm/vm86.h"
 unsigned long flags;
 unsigned long screen_bitmap;
 unsigned long cpu_type;
 struct revectored_struct int_revectored;
 struct revectored_struct int21_revectored;
 struct vm86plus_info_struct vm86plus;
 struct pt_regs *regs32;
# 59 "/usr/src/linux-2.6/arch/x86/include/asm/vm86.h"
};



void handle_vm86_fault(struct kernel_vm86_regs *, long);
int handle_vm86_trap(struct kernel_vm86_regs *, long, int);
struct pt_regs *save_v86_state(struct kernel_vm86_regs *);

struct task_struct;
void release_vm86_irqs(struct task_struct *);
# 11 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/math_emu.h" 1
# 11 "/usr/src/linux-2.6/arch/x86/include/asm/math_emu.h"
struct math_emu_info {
 long ___orig_eip;
 union {
  struct pt_regs *regs;
  struct kernel_vm86_regs *vm86;
 };
};
# 12 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2


# 1 "/usr/src/linux-2.6/arch/x86/include/asm/sigcontext.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/sigcontext.h" 1
# 23 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/sigcontext.h"
struct _fpx_sw_bytes {
 __u32 magic1;
 __u32 extended_size;


 __u64 xstate_bv;




 __u32 xstate_size;




 __u32 padding[7];
};
# 56 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/sigcontext.h"
struct _fpreg {
 unsigned short significand[4];
 unsigned short exponent;
};

struct _fpxreg {
 unsigned short significand[4];
 unsigned short exponent;
 unsigned short padding[3];
};

struct _xmmreg {
 unsigned long element[4];
};

struct _fpstate {

 unsigned long cw;
 unsigned long sw;
 unsigned long tag;
 unsigned long ipoff;
 unsigned long cssel;
 unsigned long dataoff;
 unsigned long datasel;
 struct _fpreg _st[8];
 unsigned short status;
 unsigned short magic;


 unsigned long _fxsr_env[6];
 unsigned long mxcsr;
 unsigned long reserved;
 struct _fpxreg _fxsr_st[8];
 struct _xmmreg _xmm[8];
 unsigned long padding1[44];

 union {
  unsigned long padding2[12];
  struct _fpx_sw_bytes sw_reserved;

 };
};
# 197 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/sigcontext.h"
struct _xsave_hdr {
 __u64 xstate_bv;
 __u64 reserved1[2];
 __u64 reserved2[5];
};

struct _ymmh_state {

 __u32 ymmh_space[64];
};







struct _xstate {
 struct _fpstate fpstate;
 struct _xsave_hdr xstate_hdr;
 struct _ymmh_state ymmh;

};
# 5 "/usr/src/linux-2.6/arch/x86/include/asm/sigcontext.h" 2


struct sigcontext {
 unsigned short gs, __gsh;
 unsigned short fs, __fsh;
 unsigned short es, __esh;
 unsigned short ds, __dsh;
 unsigned long di;
 unsigned long si;
 unsigned long bp;
 unsigned long sp;
 unsigned long bx;
 unsigned long dx;
 unsigned long cx;
 unsigned long ax;
 unsigned long trapno;
 unsigned long err;
 unsigned long ip;
 unsigned short cs, __csh;
 unsigned long flags;
 unsigned long sp_at_signal;
 unsigned short ss, __ssh;
# 35 "/usr/src/linux-2.6/arch/x86/include/asm/sigcontext.h"
 void *fpstate;
 unsigned long oldmask;
 unsigned long cr2;
};
# 15 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/current.h" 1







struct task_struct;

extern __attribute__((section(".data" ""))) __typeof__(struct task_struct *=
) current_task;

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) struct task_struct *get_current(void)
{
 return ({ typeof(current_task) pfo_ret__; switch (sizeof(current_task)) { =
case 1: asm("mov" "b """ "%P" "1"",%0" : "=3Dq" (pfo_ret__) : "p" (&(curren=
t_task))); break; case 2: asm("mov" "w """ "%P" "1"",%0" : "=3Dr" (pfo_ret_=
_) : "p" (&(current_task))); break; case 4: asm("mov" "l """ "%P" "1"",%0" =
: "=3Dr" (pfo_ret__) : "p" (&(current_task))); break; case 8: asm("mov" "q =
""" "%P" "1"",%0" : "=3Dr" (pfo_ret__) : "p" (&(current_task))); break; def=
ault: __bad_percpu_size(); } pfo_ret__; });
}
# 16 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2


# 1 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_types.h" 1
# 227 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_types.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_32_types.h" 1
# 14 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_32_types.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable-2level_types.h" 1






typedef unsigned long pteval_t;
typedef unsigned long pmdval_t;
typedef unsigned long pudval_t;
typedef unsigned long pgdval_t;
typedef unsigned long pgprotval_t;

typedef union {
 pteval_t pte;
 pteval_t pte_low;
} pte_t;
# 15 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_32_types.h" 2
# 30 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_32_types.h"
extern bool __vmalloc_start_set;
# 228 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_types.h" 2
# 242 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_types.h"
typedef struct pgprot { pgprotval_t pgprot; } pgprot_t;

typedef struct { pgdval_t pgd; } pgd_t;

static inline __attribute__((no_instrument_function)) pgd_t native_make_pgd=
(pgdval_t val)
{
 return (pgd_t) { val };
}

static inline __attribute__((no_instrument_function)) pgdval_t native_pgd_v=
al(pgd_t pgd)
{
 return pgd.pgd;
}

static inline __attribute__((no_instrument_function)) pgdval_t pgd_flags(pg=
d_t pgd)
{
 return native_pgd_val(pgd) & (~((pteval_t)(((signed long)(~(((1UL) << 12)-=
1))) & ((phys_addr_t)((1ULL << 32) - 1)))));
}
# 274 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_types.h"
# 1 "/usr/src/linux-2.6/include/asm-generic/pgtable-nopud.h" 1
# 13 "/usr/src/linux-2.6/include/asm-generic/pgtable-nopud.h"
typedef struct { pgd_t pgd; } pud_t;
# 25 "/usr/src/linux-2.6/include/asm-generic/pgtable-nopud.h"
static inline __attribute__((no_instrument_function)) int pgd_none(pgd_t pg=
d) { return 0; }
static inline __attribute__((no_instrument_function)) int pgd_bad(pgd_t pgd=
) { return 0; }
static inline __attribute__((no_instrument_function)) int pgd_present(pgd_t=
 pgd) { return 1; }
static inline __attribute__((no_instrument_function)) void pgd_clear(pgd_t =
*pgd) { }
# 38 "/usr/src/linux-2.6/include/asm-generic/pgtable-nopud.h"
static inline __attribute__((no_instrument_function)) pud_t * pud_offset(pg=
d_t * pgd, unsigned long address)
{
 return (pud_t *)pgd;
}
# 275 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_types.h" 2

static inline __attribute__((no_instrument_function)) pudval_t native_pud_v=
al(pud_t pud)
{
 return native_pgd_val(pud.pgd);
}
# 295 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_types.h"
# 1 "/usr/src/linux-2.6/include/asm-generic/pgtable-nopmd.h" 1







struct mm_struct;
# 17 "/usr/src/linux-2.6/include/asm-generic/pgtable-nopmd.h"
typedef struct { pud_t pud; } pmd_t;
# 29 "/usr/src/linux-2.6/include/asm-generic/pgtable-nopmd.h"
static inline __attribute__((no_instrument_function)) int pud_none(pud_t pu=
d) { return 0; }
static inline __attribute__((no_instrument_function)) int pud_bad(pud_t pud=
) { return 0; }
static inline __attribute__((no_instrument_function)) int pud_present(pud_t=
 pud) { return 1; }
static inline __attribute__((no_instrument_function)) void pud_clear(pud_t =
*pud) { }
# 43 "/usr/src/linux-2.6/include/asm-generic/pgtable-nopmd.h"
static inline __attribute__((no_instrument_function)) pmd_t * pmd_offset(pu=
d_t * pud, unsigned long address)
{
 return (pmd_t *)pud;
}
# 59 "/usr/src/linux-2.6/include/asm-generic/pgtable-nopmd.h"
static inline __attribute__((no_instrument_function)) void pmd_free(struct =
mm_struct *mm, pmd_t *pmd)
{
}
# 296 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_types.h" 2

static inline __attribute__((no_instrument_function)) pmdval_t native_pmd_v=
al(pmd_t pmd)
{
 return native_pgd_val(pmd.pud.pgd);
}


static inline __attribute__((no_instrument_function)) pudval_t pud_flags(pu=
d_t pud)
{
 return native_pud_val(pud) & (~((pteval_t)(((signed long)(~(((1UL) << 12)-=
1))) & ((phys_addr_t)((1ULL << 32) - 1)))));
}

static inline __attribute__((no_instrument_function)) pmdval_t pmd_flags(pm=
d_t pmd)
{
 return native_pmd_val(pmd) & (~((pteval_t)(((signed long)(~(((1UL) << 12)-=
1))) & ((phys_addr_t)((1ULL << 32) - 1)))));
}

static inline __attribute__((no_instrument_function)) pte_t native_make_pte=
(pteval_t val)
{
 return (pte_t) { .pte =3D val };
}

static inline __attribute__((no_instrument_function)) pteval_t native_pte_v=
al(pte_t pte)
{
 return pte.pte;
}

static inline __attribute__((no_instrument_function)) pteval_t pte_flags(pt=
e_t pte)
{
 return native_pte_val(pte) & (~((pteval_t)(((signed long)(~(((1UL) << 12)-=
1))) & ((phys_addr_t)((1ULL << 32) - 1)))));
}





typedef struct page *pgtable_t;

extern pteval_t __supported_pte_mask;
extern void set_nx(void);
extern int nx_enabled;


extern pgprot_t pgprot_writecombine(pgprot_t prot);





struct file;
pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
                              unsigned long size, pgprot_t vma_prot);
int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
                              unsigned long size, pgprot_t *vma_prot);


void set_pte_vaddr(unsigned long vaddr, pte_t pte);


extern void native_pagetable_init(void);




struct seq_file;
extern void arch_report_meminfo(struct seq_file *m);

enum pg_level {
 PG_LEVEL_NONE,
 PG_LEVEL_4K,
 PG_LEVEL_2M,
 PG_LEVEL_1G,
 PG_LEVEL_NUM
};


extern void update_page_count(int level, unsigned long pages);
# 383 "/usr/src/linux-2.6/arch/x86/include/asm/pgtable_types.h"
extern pte_t *lookup_address(unsigned long address, unsigned int *level);
extern phys_addr_t slow_virt_to_phys(void *__address);
# 19 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2

# 1 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/msr.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/msr-index.h" 1
# 5 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/msr.h" 2




# 1 "/usr/src/linux-2.6/include/uapi/linux/ioctl.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/ioctl.h" 1
# 1 "/usr/src/linux-2.6/include/asm-generic/ioctl.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/ioctl.h" 1
# 5 "/usr/src/linux-2.6/include/asm-generic/ioctl.h" 2


extern unsigned int __invalid_size_argument_for_IOC;
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/ioctl.h" 2
# 5 "/usr/src/linux-2.6/include/uapi/linux/ioctl.h" 2
# 10 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/msr.h" 2
# 5 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h" 2




# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/errno.h" 1
# 10 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/cpumask.h" 1



# 1 "/usr/src/linux-2.6/include/linux/cpumask.h" 1
# 11 "/usr/src/linux-2.6/include/linux/cpumask.h"
# 1 "/usr/src/linux-2.6/include/linux/bitmap.h" 1
# 91 "/usr/src/linux-2.6/include/linux/bitmap.h"
extern int __bitmap_empty(const unsigned long *bitmap, int bits);
extern int __bitmap_full(const unsigned long *bitmap, int bits);
extern int __bitmap_equal(const unsigned long *bitmap1,
                 const unsigned long *bitmap2, int bits);
extern void __bitmap_complement(unsigned long *dst, const unsigned long *sr=
c,
   int bits);
extern void __bitmap_shift_right(unsigned long *dst,
                        const unsigned long *src, int shift, int bits);
extern void __bitmap_shift_left(unsigned long *dst,
                        const unsigned long *src, int shift, int bits);
extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
   const unsigned long *bitmap2, int bits);
extern void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
   const unsigned long *bitmap2, int bits);
extern void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
   const unsigned long *bitmap2, int bits);
extern int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
   const unsigned long *bitmap2, int bits);
extern int __bitmap_intersects(const unsigned long *bitmap1,
   const unsigned long *bitmap2, int bits);
extern int __bitmap_subset(const unsigned long *bitmap1,
   const unsigned long *bitmap2, int bits);
extern int __bitmap_weight(const unsigned long *bitmap, int bits);

extern void bitmap_set(unsigned long *map, int i, int len);
extern void bitmap_clear(unsigned long *map, int start, int nr);
extern unsigned long bitmap_find_next_zero_area(unsigned long *map,
      unsigned long size,
      unsigned long start,
      unsigned int nr,
      unsigned long align_mask);

extern int bitmap_scnprintf(char *buf, unsigned int len,
   const unsigned long *src, int nbits);
extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
   unsigned long *dst, int nbits);
extern int bitmap_parse_user(const char *ubuf, unsigned int ulen,
   unsigned long *dst, int nbits);
extern int bitmap_scnlistprintf(char *buf, unsigned int len,
   const unsigned long *src, int nbits);
extern int bitmap_parselist(const char *buf, unsigned long *maskp,
   int nmaskbits);
extern int bitmap_parselist_user(const char *ubuf, unsigned int ulen,
   unsigned long *dst, int nbits);
extern void bitmap_remap(unsigned long *dst, const unsigned long *src,
  const unsigned long *old, const unsigned long *new, int bits);
extern int bitmap_bitremap(int oldbit,
  const unsigned long *old, const unsigned long *new, int bits);
extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
  const unsigned long *relmap, int bits);
extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
  int sz, int bits);
extern int bitmap_find_free_region(unsigned long *bitmap, int bits, int ord=
er);
extern void bitmap_release_region(unsigned long *bitmap, int pos, int order=
);
extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order=
);
extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
# 159 "/usr/src/linux-2.6/include/linux/bitmap.h"
static inline __attribute__((no_instrument_function)) void bitmap_zero(unsi=
gned long *dst, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  *dst =3D 0UL;
 else {
  int len =3D (((nbits) + (8 * sizeof(long)) - 1) / (8 * sizeof(long))) * s=
izeof(unsigned long);
  __builtin_memset(dst, 0, len);
 }
}

static inline __attribute__((no_instrument_function)) void bitmap_fill(unsi=
gned long *dst, int nbits)
{
 size_t nlongs =3D (((nbits) + (8 * sizeof(long)) - 1) / (8 * sizeof(long))=
);
 if (!(__builtin_constant_p(nbits) && (nbits) <=3D 32)) {
  int len =3D (nlongs - 1) * sizeof(unsigned long);
  __builtin_memset(dst, 0xff, len);
 }
 dst[nlongs - 1] =3D ( ((nbits) % 32) ? (1UL<<((nbits) % 32))-1 : ~0UL );
}

static inline __attribute__((no_instrument_function)) void bitmap_copy(unsi=
gned long *dst, const unsigned long *src,
   int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  *dst =3D *src;
 else {
  int len =3D (((nbits) + (8 * sizeof(long)) - 1) / (8 * sizeof(long))) * s=
izeof(unsigned long);
  __builtin_memcpy(dst, src, len);
 }
}

static inline __attribute__((no_instrument_function)) int bitmap_and(unsign=
ed long *dst, const unsigned long *src1,
   const unsigned long *src2, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  return (*dst =3D *src1 & *src2) !=3D 0;
 return __bitmap_and(dst, src1, src2, nbits);
}

static inline __attribute__((no_instrument_function)) void bitmap_or(unsign=
ed long *dst, const unsigned long *src1,
   const unsigned long *src2, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  *dst =3D *src1 | *src2;
 else
  __bitmap_or(dst, src1, src2, nbits);
}

static inline __attribute__((no_instrument_function)) void bitmap_xor(unsig=
ned long *dst, const unsigned long *src1,
   const unsigned long *src2, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  *dst =3D *src1 ^ *src2;
 else
  __bitmap_xor(dst, src1, src2, nbits);
}

static inline __attribute__((no_instrument_function)) int bitmap_andnot(uns=
igned long *dst, const unsigned long *src1,
   const unsigned long *src2, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  return (*dst =3D *src1 & ~(*src2)) !=3D 0;
 return __bitmap_andnot(dst, src1, src2, nbits);
}

static inline __attribute__((no_instrument_function)) void bitmap_complemen=
t(unsigned long *dst, const unsigned long *src,
   int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  *dst =3D ~(*src) & ( ((nbits) % 32) ? (1UL<<((nbits) % 32))-1 : ~0UL );
 else
  __bitmap_complement(dst, src, nbits);
}

static inline __attribute__((no_instrument_function)) int bitmap_equal(cons=
t unsigned long *src1,
   const unsigned long *src2, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  return ! ((*src1 ^ *src2) & ( ((nbits) % 32) ? (1UL<<((nbits) % 32))-1 : =
~0UL ));
 else
  return __bitmap_equal(src1, src2, nbits);
}

static inline __attribute__((no_instrument_function)) int bitmap_intersects=
(const unsigned long *src1,
   const unsigned long *src2, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  return ((*src1 & *src2) & ( ((nbits) % 32) ? (1UL<<((nbits) % 32))-1 : ~0=
UL )) !=3D 0;
 else
  return __bitmap_intersects(src1, src2, nbits);
}

static inline __attribute__((no_instrument_function)) int bitmap_subset(con=
st unsigned long *src1,
   const unsigned long *src2, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  return ! ((*src1 & ~(*src2)) & ( ((nbits) % 32) ? (1UL<<((nbits) % 32))-1=
 : ~0UL ));
 else
  return __bitmap_subset(src1, src2, nbits);
}

static inline __attribute__((no_instrument_function)) int bitmap_empty(cons=
t unsigned long *src, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  return ! (*src & ( ((nbits) % 32) ? (1UL<<((nbits) % 32))-1 : ~0UL ));
 else
  return __bitmap_empty(src, nbits);
}

static inline __attribute__((no_instrument_function)) int bitmap_full(const=
 unsigned long *src, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  return ! (~(*src) & ( ((nbits) % 32) ? (1UL<<((nbits) % 32))-1 : ~0UL ));
 else
  return __bitmap_full(src, nbits);
}

static inline __attribute__((no_instrument_function)) int bitmap_weight(con=
st unsigned long *src, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  return hweight_long(*src & ( ((nbits) % 32) ? (1UL<<((nbits) % 32))-1 : ~=
0UL ));
 return __bitmap_weight(src, nbits);
}

static inline __attribute__((no_instrument_function)) void bitmap_shift_rig=
ht(unsigned long *dst,
   const unsigned long *src, int n, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  *dst =3D *src >> n;
 else
  __bitmap_shift_right(dst, src, n, nbits);
}

static inline __attribute__((no_instrument_function)) void bitmap_shift_lef=
t(unsigned long *dst,
   const unsigned long *src, int n, int nbits)
{
 if ((__builtin_constant_p(nbits) && (nbits) <=3D 32))
  *dst =3D (*src << n) & ( ((nbits) % 32) ? (1UL<<((nbits) % 32))-1 : ~0UL =
);
 else
  __bitmap_shift_left(dst, src, n, nbits);
}

static inline __attribute__((no_instrument_function)) int bitmap_parse(cons=
t char *buf, unsigned int buflen,
   unsigned long *maskp, int nmaskbits)
{
 return __bitmap_parse(buf, buflen, 0, maskp, nmaskbits);
}
# 12 "/usr/src/linux-2.6/include/linux/cpumask.h" 2


typedef struct cpumask { unsigned long bits[(((1) + (8 * sizeof(long)) - 1)=
 / (8 * sizeof(long)))]; } cpumask_t;
# 79 "/usr/src/linux-2.6/include/linux/cpumask.h"
extern const struct cpumask *const cpu_possible_mask;
extern const struct cpumask *const cpu_online_mask;
extern const struct cpumask *const cpu_present_mask;
extern const struct cpumask *const cpu_active_mask;
# 105 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) unsigned int cpumask_=
check(unsigned int cpu)
{



 return cpu;
}



static inline __attribute__((no_instrument_function)) unsigned int cpumask_=
first(const struct cpumask *srcp)
{
 return 0;
}


static inline __attribute__((no_instrument_function)) unsigned int cpumask_=
next(int n, const struct cpumask *srcp)
{
 return n+1;
}

static inline __attribute__((no_instrument_function)) unsigned int cpumask_=
next_zero(int n, const struct cpumask *srcp)
{
 return n+1;
}

static inline __attribute__((no_instrument_function)) unsigned int cpumask_=
next_and(int n,
         const struct cpumask *srcp,
         const struct cpumask *andp)
{
 return n+1;
}


static inline __attribute__((no_instrument_function)) unsigned int cpumask_=
any_but(const struct cpumask *mask,
        unsigned int cpu)
{
 return 1;
}
# 255 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) void cpumask_set_cpu(=
unsigned int cpu, struct cpumask *dstp)
{
 set_bit(cpumask_check(cpu), ((dstp)->bits));
}






static inline __attribute__((no_instrument_function)) void cpumask_clear_cp=
u(int cpu, struct cpumask *dstp)
{
 clear_bit(cpumask_check(cpu), ((dstp)->bits));
}
# 291 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpumask_test_and_=
set_cpu(int cpu, struct cpumask *cpumask)
{
 return test_and_set_bit(cpumask_check(cpu), ((cpumask)->bits));
}
# 305 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpumask_test_and_=
clear_cpu(int cpu, struct cpumask *cpumask)
{
 return test_and_clear_bit(cpumask_check(cpu), ((cpumask)->bits));
}





static inline __attribute__((no_instrument_function)) void cpumask_setall(s=
truct cpumask *dstp)
{
 bitmap_fill(((dstp)->bits), 1);
}





static inline __attribute__((no_instrument_function)) void cpumask_clear(st=
ruct cpumask *dstp)
{
 bitmap_zero(((dstp)->bits), 1);
}
# 336 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpumask_and(struc=
t cpumask *dstp,
          const struct cpumask *src1p,
          const struct cpumask *src2p)
{
 return bitmap_and(((dstp)->bits), ((src1p)->bits),
           ((src2p)->bits), 1);
}







static inline __attribute__((no_instrument_function)) void cpumask_or(struc=
t cpumask *dstp, const struct cpumask *src1p,
         const struct cpumask *src2p)
{
 bitmap_or(((dstp)->bits), ((src1p)->bits),
          ((src2p)->bits), 1);
}







static inline __attribute__((no_instrument_function)) void cpumask_xor(stru=
ct cpumask *dstp,
          const struct cpumask *src1p,
          const struct cpumask *src2p)
{
 bitmap_xor(((dstp)->bits), ((src1p)->bits),
           ((src2p)->bits), 1);
}
# 379 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpumask_andnot(st=
ruct cpumask *dstp,
      const struct cpumask *src1p,
      const struct cpumask *src2p)
{
 return bitmap_andnot(((dstp)->bits), ((src1p)->bits),
       ((src2p)->bits), 1);
}






static inline __attribute__((no_instrument_function)) void cpumask_compleme=
nt(struct cpumask *dstp,
          const struct cpumask *srcp)
{
 bitmap_complement(((dstp)->bits), ((srcp)->bits),
           1);
}






static inline __attribute__((no_instrument_function)) bool cpumask_equal(co=
nst struct cpumask *src1p,
    const struct cpumask *src2p)
{
 return bitmap_equal(((src1p)->bits), ((src2p)->bits),
       1);
}






static inline __attribute__((no_instrument_function)) bool cpumask_intersec=
ts(const struct cpumask *src1p,
         const struct cpumask *src2p)
{
 return bitmap_intersects(((src1p)->bits), ((src2p)->bits),
            1);
}
# 430 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpumask_subset(co=
nst struct cpumask *src1p,
     const struct cpumask *src2p)
{
 return bitmap_subset(((src1p)->bits), ((src2p)->bits),
        1);
}





static inline __attribute__((no_instrument_function)) bool cpumask_empty(co=
nst struct cpumask *srcp)
{
 return bitmap_empty(((srcp)->bits), 1);
}





static inline __attribute__((no_instrument_function)) bool cpumask_full(con=
st struct cpumask *srcp)
{
 return bitmap_full(((srcp)->bits), 1);
}





static inline __attribute__((no_instrument_function)) unsigned int cpumask_=
weight(const struct cpumask *srcp)
{
 return bitmap_weight(((srcp)->bits), 1);
}







static inline __attribute__((no_instrument_function)) void cpumask_shift_ri=
ght(struct cpumask *dstp,
           const struct cpumask *srcp, int n)
{
 bitmap_shift_right(((dstp)->bits), ((srcp)->bits), n,
            1);
}







static inline __attribute__((no_instrument_function)) void cpumask_shift_le=
ft(struct cpumask *dstp,
          const struct cpumask *srcp, int n)
{
 bitmap_shift_left(((dstp)->bits), ((srcp)->bits), n,
           1);
}






static inline __attribute__((no_instrument_function)) void cpumask_copy(str=
uct cpumask *dstp,
    const struct cpumask *srcp)
{
 bitmap_copy(((dstp)->bits), ((srcp)->bits), 1);
}
# 542 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpumask_scnprintf=
(char *buf, int len,
        const struct cpumask *srcp)
{
 return bitmap_scnprintf(buf, len, ((srcp)->bits), 1);
}
# 556 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpumask_parse_use=
r(const char *buf, int len,
         struct cpumask *dstp)
{
 return bitmap_parse_user(buf, len, ((dstp)->bits), 1);
}
# 570 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpumask_parselist=
_user(const char *buf, int len,
         struct cpumask *dstp)
{
 return bitmap_parselist_user(buf, len, ((dstp)->bits),
       1);
}
# 586 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpulist_scnprintf=
(char *buf, int len,
        const struct cpumask *srcp)
{
 return bitmap_scnlistprintf(buf, len, ((srcp)->bits),
        1);
}
# 600 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpumask_parse(con=
st char *buf, struct cpumask *dstp)
{
 char *nl =3D strchr(buf, '\n');
 int len =3D nl ? nl - buf : strlen(buf);

 return bitmap_parse(buf, len, ((dstp)->bits), 1);
}
# 615 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int cpulist_parse(con=
st char *buf, struct cpumask *dstp)
{
 return bitmap_parselist(buf, ((dstp)->bits), 1);
}






static inline __attribute__((no_instrument_function)) size_t cpumask_size(v=
oid)
{


 return (((1) + (8 * sizeof(long)) - 1) / (8 * sizeof(long))) * sizeof(long=
);
}
# 674 "/usr/src/linux-2.6/include/linux/cpumask.h"
typedef struct cpumask cpumask_var_t[1];

static inline __attribute__((no_instrument_function)) bool alloc_cpumask_va=
r(cpumask_var_t *mask, gfp_t flags)
{
 return true;
}

static inline __attribute__((no_instrument_function)) bool alloc_cpumask_va=
r_node(cpumask_var_t *mask, gfp_t flags,
       int node)
{
 return true;
}

static inline __attribute__((no_instrument_function)) bool zalloc_cpumask_v=
ar(cpumask_var_t *mask, gfp_t flags)
{
 cpumask_clear(*mask);
 return true;
}

static inline __attribute__((no_instrument_function)) bool zalloc_cpumask_v=
ar_node(cpumask_var_t *mask, gfp_t flags,
       int node)
{
 cpumask_clear(*mask);
 return true;
}

static inline __attribute__((no_instrument_function)) void alloc_bootmem_cp=
umask_var(cpumask_var_t *mask)
{
}

static inline __attribute__((no_instrument_function)) void free_cpumask_var=
(cpumask_var_t mask)
{
}

static inline __attribute__((no_instrument_function)) void free_bootmem_cpu=
mask_var(cpumask_var_t mask)
{
}




extern const unsigned long cpu_all_bits[(((1) + (8 * sizeof(long)) - 1) / (=
8 * sizeof(long)))];
# 726 "/usr/src/linux-2.6/include/linux/cpumask.h"
void set_cpu_possible(unsigned int cpu, bool possible);
void set_cpu_present(unsigned int cpu, bool present);
void set_cpu_online(unsigned int cpu, bool online);
void set_cpu_active(unsigned int cpu, bool active);
void init_cpu_present(const struct cpumask *src);
void init_cpu_possible(const struct cpumask *src);
void init_cpu_online(const struct cpumask *src);
# 748 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) int __check_is_bitmap=
(const unsigned long *bitmap)
{
 return 1;
}
# 760 "/usr/src/linux-2.6/include/linux/cpumask.h"
extern const unsigned long
 cpu_bit_bitmap[32 +1][(((1) + (8 * sizeof(long)) - 1) / (8 * sizeof(long))=
)];

static inline __attribute__((no_instrument_function)) const struct cpumask =
*get_cpu_mask(unsigned int cpu)
{
 const unsigned long *p =3D cpu_bit_bitmap[1 + cpu % 32];
 p -=3D cpu / 32;
 return ((struct cpumask *)(1 ? (p) : (void *)sizeof(__check_is_bitmap(p)))=
);
}
# 860 "/usr/src/linux-2.6/include/linux/cpumask.h"
static inline __attribute__((no_instrument_function)) void __cpu_set(int cp=
u, volatile cpumask_t *dstp)
{
 set_bit(cpu, dstp->bits);
}


static inline __attribute__((no_instrument_function)) void __cpu_clear(int =
cpu, volatile cpumask_t *dstp)
{
 clear_bit(cpu, dstp->bits);
}


static inline __attribute__((no_instrument_function)) void __cpus_setall(cp=
umask_t *dstp, int nbits)
{
 bitmap_fill(dstp->bits, nbits);
}


static inline __attribute__((no_instrument_function)) void __cpus_clear(cpu=
mask_t *dstp, int nbits)
{
 bitmap_zero(dstp->bits, nbits);
}





static inline __attribute__((no_instrument_function)) int __cpu_test_and_se=
t(int cpu, cpumask_t *addr)
{
 return test_and_set_bit(cpu, addr->bits);
}


static inline __attribute__((no_instrument_function)) int __cpus_and(cpumas=
k_t *dstp, const cpumask_t *src1p,
     const cpumask_t *src2p, int nbits)
{
 return bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
}


static inline __attribute__((no_instrument_function)) void __cpus_or(cpumas=
k_t *dstp, const cpumask_t *src1p,
     const cpumask_t *src2p, int nbits)
{
 bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
}


static inline __attribute__((no_instrument_function)) void __cpus_xor(cpuma=
sk_t *dstp, const cpumask_t *src1p,
     const cpumask_t *src2p, int nbits)
{
 bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
}



static inline __attribute__((no_instrument_function)) int __cpus_andnot(cpu=
mask_t *dstp, const cpumask_t *src1p,
     const cpumask_t *src2p, int nbits)
{
 return bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
}


static inline __attribute__((no_instrument_function)) int __cpus_equal(cons=
t cpumask_t *src1p,
     const cpumask_t *src2p, int nbits)
{
 return bitmap_equal(src1p->bits, src2p->bits, nbits);
}


static inline __attribute__((no_instrument_function)) int __cpus_intersects=
(const cpumask_t *src1p,
     const cpumask_t *src2p, int nbits)
{
 return bitmap_intersects(src1p->bits, src2p->bits, nbits);
}


static inline __attribute__((no_instrument_function)) int __cpus_subset(con=
st cpumask_t *src1p,
     const cpumask_t *src2p, int nbits)
{
 return bitmap_subset(src1p->bits, src2p->bits, nbits);
}


static inline __attribute__((no_instrument_function)) int __cpus_empty(cons=
t cpumask_t *srcp, int nbits)
{
 return bitmap_empty(srcp->bits, nbits);
}


static inline __attribute__((no_instrument_function)) int __cpus_weight(con=
st cpumask_t *srcp, int nbits)
{
 return bitmap_weight(srcp->bits, nbits);
}



static inline __attribute__((no_instrument_function)) void __cpus_shift_lef=
t(cpumask_t *dstp,
     const cpumask_t *srcp, int n, int nbits)
{
 bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
}
# 5 "/usr/src/linux-2.6/arch/x86/include/asm/cpumask.h" 2

extern cpumask_var_t cpu_callin_mask;
extern cpumask_var_t cpu_callout_mask;
extern cpumask_var_t cpu_initialized_mask;
extern cpumask_var_t cpu_sibling_setup_mask;

extern void setup_cpu_local_masks(void);
# 11 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h" 2

struct msr {
 union {
  struct {
   u32 l;
   u32 h;
  };
  u64 q;
 };
};

struct msr_info {
 u32 msr_no;
 struct msr reg;
 struct msr *msrs;
 int err;
};

struct msr_regs_info {
 u32 *regs;
 int err;
};

static inline __attribute__((no_instrument_function)) unsigned long long na=
tive_read_tscp(unsigned int *aux)
{
 unsigned long low, high;
 asm volatile(".byte 0x0f,0x01,0xf9"
       : "=3Da" (low), "=3Dd" (high), "=3Dc" (*aux));
 return low | ((u64)high << 32);
}
# 60 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h"
static inline __attribute__((no_instrument_function)) unsigned long long na=
tive_read_msr(unsigned int msr)
{
 unsigned long long val;

 asm volatile("rdmsr" : "=3DA" (val) : "c" (msr));
 return (val);
}

static inline __attribute__((no_instrument_function)) unsigned long long na=
tive_read_msr_safe(unsigned int msr,
            int *err)
{
 unsigned long long val;

 asm volatile("2: rdmsr ; xor %[err],%[err]\n"
       "1:\n\t"
       ".section .fixup,\"ax\"\n\t"
       "3:  mov %[fault],%[err] ; jmp 1b\n\t"
       ".previous\n\t"
       " .pushsection \"__ex_table\",\"a\"\n" " .balign 8\n" " .long (" "2b=
" ") - .\n" " .long (" "3b" ") - .\n" " .popsection\n"
       : [err] "=3Dr" (*err), "=3DA" (val)
       : "c" (msr), [fault] "i" (-5));
 return (val);
}

static inline __attribute__((no_instrument_function)) void native_write_msr=
(unsigned int msr,
        unsigned low, unsigned high)
{
 asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high) : "memory");
}


__attribute__((no_instrument_function)) static inline __attribute__((no_ins=
trument_function)) int native_write_msr_safe(unsigned int msr,
     unsigned low, unsigned high)
{
 int err;
 asm volatile("2: wrmsr ; xor %[err],%[err]\n"
       "1:\n\t"
       ".section .fixup,\"ax\"\n\t"
       "3:  mov %[fault],%[err] ; jmp 1b\n\t"
       ".previous\n\t"
       " .pushsection \"__ex_table\",\"a\"\n" " .balign 8\n" " .long (" "2b=
" ") - .\n" " .long (" "3b" ") - .\n" " .popsection\n"
       : [err] "=3Da" (err)
       : "c" (msr), "0" (low), "d" (high),
         [fault] "i" (-5)
       : "memory");
 return err;
}

extern unsigned long long native_read_tsc(void);

extern int rdmsr_safe_regs(u32 regs[8]);
extern int wrmsr_safe_regs(u32 regs[8]);

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) unsigned long long __native_read_tsc(void)
{
 unsigned long long val;

 asm volatile("rdtsc" : "=3DA" (val));

 return (val);
}

static inline __attribute__((no_instrument_function)) unsigned long long na=
tive_read_pmc(int counter)
{
 unsigned long long val;

 asm volatile("rdpmc" : "=3DA" (val) : "c" (counter));
 return (val);
}
# 147 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h"
static inline __attribute__((no_instrument_function)) void wrmsr(unsigned m=
sr, unsigned low, unsigned high)
{
 native_write_msr(msr, low, high);
}
# 159 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h"
static inline __attribute__((no_instrument_function)) int wrmsr_safe(unsign=
ed msr, unsigned low, unsigned high)
{
 return native_write_msr_safe(msr, low, high);
}
# 174 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h"
static inline __attribute__((no_instrument_function)) int rdmsrl_safe(unsig=
ned msr, unsigned long long *p)
{
 int err;

 *p =3D native_read_msr_safe(msr, &err);
 return err;
}
# 215 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h"
struct msr *msrs_alloc(void);
void msrs_free(struct msr *msrs);
# 228 "/usr/src/linux-2.6/arch/x86/include/asm/msr.h"
static inline __attribute__((no_instrument_function)) int rdmsr_on_cpu(unsi=
gned int cpu, u32 msr_no, u32 *l, u32 *h)
{
 do { u64 __val =3D native_read_msr((msr_no)); (void)((*l) =3D (u32)__val);=
 (void)((*h) =3D (u32)(__val >> 32)); } while (0);
 return 0;
}
static inline __attribute__((no_instrument_function)) int wrmsr_on_cpu(unsi=
gned int cpu, u32 msr_no, u32 l, u32 h)
{
 wrmsr(msr_no, l, h);
 return 0;
}
static inline __attribute__((no_instrument_function)) void rdmsr_on_cpus(co=
nst struct cpumask *m, u32 msr_no,
    struct msr *msrs)
{
       rdmsr_on_cpu(0, msr_no, &(msrs[0].l), &(msrs[0].h));
}
static inline __attribute__((no_instrument_function)) void wrmsr_on_cpus(co=
nst struct cpumask *m, u32 msr_no,
    struct msr *msrs)
{
       wrmsr_on_cpu(0, msr_no, msrs[0].l, msrs[0].h);
}
static inline __attribute__((no_instrument_function)) int rdmsr_safe_on_cpu=
(unsigned int cpu, u32 msr_no,
        u32 *l, u32 *h)
{
 return ({ int __err; u64 __val =3D native_read_msr_safe((msr_no), &__err);=
 (*l) =3D (u32)__val; (*h) =3D (u32)(__val >> 32); __err; });
}
static inline __attribute__((no_instrument_function)) int wrmsr_safe_on_cpu=
(unsigned int cpu, u32 msr_no, u32 l, u32 h)
{
 return wrmsr_safe(msr_no, l, h);
}
static inline __attribute__((no_instrument_function)) int rdmsr_safe_regs_o=
n_cpu(unsigned int cpu, u32 regs[8])
{
 return rdmsr_safe_regs(regs);
}
static inline __attribute__((no_instrument_function)) int wrmsr_safe_regs_o=
n_cpu(unsigned int cpu, u32 regs[8])
{
 return wrmsr_safe_regs(regs);
}
# 21 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/desc_defs.h" 1
# 22 "/usr/src/linux-2.6/arch/x86/include/asm/desc_defs.h"
struct desc_struct {
 union {
  struct {
   unsigned int a;
   unsigned int b;
  };
  struct {
   u16 limit0;
   u16 base0;
   unsigned base1: 8, type: 4, s: 1, dpl: 2, p: 1;
   unsigned limit: 4, avl: 1, l: 1, d: 1, g: 1, base2: 8;
  };
 };
} __attribute__((packed));







enum {
 GATE_INTERRUPT =3D 0xE,
 GATE_TRAP =3D 0xF,
 GATE_CALL =3D 0xC,
 GATE_TASK =3D 0x5,
};


struct gate_struct64 {
 u16 offset_low;
 u16 segment;
 unsigned ist : 3, zero0 : 5, type : 5, dpl : 2, p : 1;
 u16 offset_middle;
 u32 offset_high;
 u32 zero1;
} __attribute__((packed));





enum {
 DESC_TSS =3D 0x9,
 DESC_LDT =3D 0x2,
 DESCTYPE_S =3D 0x10,
};


struct ldttss_desc64 {
 u16 limit0;
 u16 base0;
 unsigned base1 : 8, type : 5, dpl : 2, p : 1;
 unsigned limit1 : 4, zero0 : 3, g : 1, base2 : 8;
 u32 base3;
 u32 zero1;
} __attribute__((packed));
# 87 "/usr/src/linux-2.6/arch/x86/include/asm/desc_defs.h"
typedef struct desc_struct gate_desc;
typedef struct desc_struct ldt_desc;
typedef struct desc_struct tss_desc;




struct desc_ptr {
 unsigned short size;
 unsigned long address;
} __attribute__((packed)) ;
# 22 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/nops.h" 1
# 142 "/usr/src/linux-2.6/arch/x86/include/asm/nops.h"
extern const unsigned char * const *ideal_nops;
extern void arch_init_ideal_nops(void);
# 23 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/special_insns.h" 1






static inline __attribute__((no_instrument_function)) void native_clts(void)
{
 asm volatile("clts");
}
# 19 "/usr/src/linux-2.6/arch/x86/include/asm/special_insns.h"
extern unsigned long __force_order;

static inline __attribute__((no_instrument_function)) unsigned long native_=
read_cr0(void)
{
 unsigned long val;
 asm volatile("mov %%cr0,%0\n\t" : "=3Dr" (val), "=3Dm" (__force_order));
 return val;
}

static inline __attribute__((no_instrument_function)) void native_write_cr0=
(unsigned long val)
{
 asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
}

static inline __attribute__((no_instrument_function)) unsigned long native_=
read_cr2(void)
{
 unsigned long val;
 asm volatile("mov %%cr2,%0\n\t" : "=3Dr" (val), "=3Dm" (__force_order));
 return val;
}

static inline __attribute__((no_instrument_function)) void native_write_cr2=
(unsigned long val)
{
 asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
}

static inline __attribute__((no_instrument_function)) unsigned long native_=
read_cr3(void)
{
 unsigned long val;
 asm volatile("mov %%cr3,%0\n\t" : "=3Dr" (val), "=3Dm" (__force_order));
 return val;
}

static inline __attribute__((no_instrument_function)) void native_write_cr3=
(unsigned long val)
{
 asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
}

static inline __attribute__((no_instrument_function)) unsigned long native_=
read_cr4(void)
{
 unsigned long val;
 asm volatile("mov %%cr4,%0\n\t" : "=3Dr" (val), "=3Dm" (__force_order));
 return val;
}

static inline __attribute__((no_instrument_function)) unsigned long native_=
read_cr4_safe(void)
{
 unsigned long val;



 asm volatile("1: mov %%cr4, %0\n"
       "2:\n"
       " .pushsection \"__ex_table\",\"a\"\n" " .balign 8\n" " .long (" "1b=
" ") - .\n" " .long (" "2b" ") - .\n" " .popsection\n"
       : "=3Dr" (val), "=3Dm" (__force_order) : "0" (0));



 return val;
}

static inline __attribute__((no_instrument_function)) void native_write_cr4=
(unsigned long val)
{
 asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
}
# 99 "/usr/src/linux-2.6/arch/x86/include/asm/special_insns.h"
static inline __attribute__((no_instrument_function)) void native_wbinvd(vo=
id)
{
 asm volatile("wbinvd": : :"memory");
}

extern __attribute__((regparm(0))) void native_load_gs_index(unsigned);





static inline __attribute__((no_instrument_function)) unsigned long read_cr=
0(void)
{
 return native_read_cr0();
}

static inline __attribute__((no_instrument_function)) void write_cr0(unsign=
ed long x)
{
 native_write_cr0(x);
}

static inline __attribute__((no_instrument_function)) unsigned long read_cr=
2(void)
{
 return native_read_cr2();
}

static inline __attribute__((no_instrument_function)) void write_cr2(unsign=
ed long x)
{
 native_write_cr2(x);
}

static inline __attribute__((no_instrument_function)) unsigned long read_cr=
3(void)
{
 return native_read_cr3();
}

static inline __attribute__((no_instrument_function)) void write_cr3(unsign=
ed long x)
{
 native_write_cr3(x);
}

static inline __attribute__((no_instrument_function)) unsigned long read_cr=
4(void)
{
 return native_read_cr4();
}

static inline __attribute__((no_instrument_function)) unsigned long read_cr=
4_safe(void)
{
 return native_read_cr4_safe();
}

static inline __attribute__((no_instrument_function)) void write_cr4(unsign=
ed long x)
{
 native_write_cr4(x);
}

static inline __attribute__((no_instrument_function)) void wbinvd(void)
{
 native_wbinvd();
}
# 180 "/usr/src/linux-2.6/arch/x86/include/asm/special_insns.h"
static inline __attribute__((no_instrument_function)) void clts(void)
{
 native_clts();
}





static inline __attribute__((no_instrument_function)) void clflush(volatile=
 void *__p)
{
 asm volatile("clflush %0" : "+m" (*(volatile char *)__p));
}
# 24 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2

# 1 "/usr/src/linux-2.6/include/linux/personality.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/personality.h" 1
# 10 "/usr/src/linux-2.6/include/uapi/linux/personality.h"
enum {
 UNAME26 =3D 0x0020000,
 ADDR_NO_RANDOMIZE =3D 0x0040000,
 FDPIC_FUNCPTRS =3D 0x0080000,


 MMAP_PAGE_ZERO =3D 0x0100000,
 ADDR_COMPAT_LAYOUT =3D 0x0200000,
 READ_IMPLIES_EXEC =3D 0x0400000,
 ADDR_LIMIT_32BIT =3D 0x0800000,
 SHORT_INODE =3D 0x1000000,
 WHOLE_SECONDS =3D 0x2000000,
 STICKY_TIMEOUTS =3D 0x4000000,
 ADDR_LIMIT_3GB =3D 0x8000000,
};
# 41 "/usr/src/linux-2.6/include/uapi/linux/personality.h"
enum {
 PER_LINUX =3D 0x0000,
 PER_LINUX_32BIT =3D 0x0000 | ADDR_LIMIT_32BIT,
 PER_LINUX_FDPIC =3D 0x0000 | FDPIC_FUNCPTRS,
 PER_SVR4 =3D 0x0001 | STICKY_TIMEOUTS | MMAP_PAGE_ZERO,
 PER_SVR3 =3D 0x0002 | STICKY_TIMEOUTS | SHORT_INODE,
 PER_SCOSVR3 =3D 0x0003 | STICKY_TIMEOUTS |
      WHOLE_SECONDS | SHORT_INODE,
 PER_OSR5 =3D 0x0003 | STICKY_TIMEOUTS | WHOLE_SECONDS,
 PER_WYSEV386 =3D 0x0004 | STICKY_TIMEOUTS | SHORT_INODE,
 PER_ISCR4 =3D 0x0005 | STICKY_TIMEOUTS,
 PER_BSD =3D 0x0006,
 PER_SUNOS =3D 0x0006 | STICKY_TIMEOUTS,
 PER_XENIX =3D 0x0007 | STICKY_TIMEOUTS | SHORT_INODE,
 PER_LINUX32 =3D 0x0008,
 PER_LINUX32_3GB =3D 0x0008 | ADDR_LIMIT_3GB,
 PER_IRIX32 =3D 0x0009 | STICKY_TIMEOUTS,
 PER_IRIXN32 =3D 0x000a | STICKY_TIMEOUTS,
 PER_IRIX64 =3D 0x000b | STICKY_TIMEOUTS,
 PER_RISCOS =3D 0x000c,
 PER_SOLARIS =3D 0x000d | STICKY_TIMEOUTS,
 PER_UW7 =3D 0x000e | STICKY_TIMEOUTS | MMAP_PAGE_ZERO,
 PER_OSF4 =3D 0x000f,
 PER_HPUX =3D 0x0010,
 PER_MASK =3D 0x00ff,
};
# 5 "/usr/src/linux-2.6/include/linux/personality.h" 2






struct exec_domain;
struct pt_regs;

extern int register_exec_domain(struct exec_domain *);
extern int unregister_exec_domain(struct exec_domain *);
extern int __set_personality(unsigned int);
# 25 "/usr/src/linux-2.6/include/linux/personality.h"
typedef void (*handler_t)(int, struct pt_regs *);

struct exec_domain {
 const char *name;
 handler_t handler;
 unsigned char pers_low;
 unsigned char pers_high;
 unsigned long *signal_map;
 unsigned long *signal_invmap;
 struct map_segment *err_map;
 struct map_segment *socktype_map;
 struct map_segment *sockopt_map;
 struct map_segment *af_map;
 struct module *module;
 struct exec_domain *next;
};
# 26 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2

# 1 "/usr/src/linux-2.6/include/linux/cache.h" 1




# 1 "/usr/src/linux-2.6/arch/x86/include/asm/cache.h" 1
# 6 "/usr/src/linux-2.6/include/linux/cache.h" 2
# 28 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2

# 1 "/usr/src/linux-2.6/include/linux/math64.h" 1
# 72 "/usr/src/linux-2.6/include/linux/math64.h"
extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);



extern u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder);



extern u64 div64_u64(u64 dividend, u64 divisor);



extern s64 div64_s64(s64 dividend, s64 divisor);
# 97 "/usr/src/linux-2.6/include/linux/math64.h"
static inline __attribute__((no_instrument_function)) u64 div_u64(u64 divid=
end, u32 divisor)
{
 u32 remainder;
 return div_u64_rem(dividend, divisor, &remainder);
}






static inline __attribute__((no_instrument_function)) s64 div_s64(s64 divid=
end, s32 divisor)
{
 s32 remainder;
 return div_s64_rem(dividend, divisor, &remainder);
}


u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) u32
__iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
{
 u32 ret =3D 0;

 while (dividend >=3D divisor) {


  asm("" : "+rm"(dividend));

  dividend -=3D divisor;
  ret++;
 }

 *remainder =3D dividend;

 return ret;
}
# 30 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2

# 1 "/usr/src/linux-2.6/include/linux/err.h" 1





# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/errno.h" 1
# 7 "/usr/src/linux-2.6/include/linux/err.h" 2
# 22 "/usr/src/linux-2.6/include/linux/err.h"
static inline __attribute__((no_instrument_function)) void * __attribute__(=
(warn_unused_result)) ERR_PTR(long error)
{
 return (void *) error;
}

static inline __attribute__((no_instrument_function)) long __attribute__((w=
arn_unused_result)) PTR_ERR( const void *ptr)
{
 return (long) ptr;
}

static inline __attribute__((no_instrument_function)) long __attribute__((w=
arn_unused_result)) IS_ERR( const void *ptr)
{
 return __builtin_expect(!!(((unsigned long)ptr) >=3D (unsigned long)-4095)=
, 0);
}

static inline __attribute__((no_instrument_function)) long __attribute__((w=
arn_unused_result)) IS_ERR_OR_NULL( const void *ptr)
{
 return !ptr || __builtin_expect(!!(((unsigned long)ptr) >=3D (unsigned lon=
g)-4095), 0);
}
# 49 "/usr/src/linux-2.6/include/linux/err.h"
static inline __attribute__((no_instrument_function)) void * __attribute__(=
(warn_unused_result)) ERR_CAST( const void *ptr)
{

 return (void *) ptr;
}

static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) PTR_ERR_OR_ZERO( const void *ptr)
{
 if (IS_ERR(ptr))
  return PTR_ERR(ptr);
 else
  return 0;
}
# 32 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2
# 1 "/usr/src/linux-2.6/include/linux/irqflags.h" 1
# 15 "/usr/src/linux-2.6/include/linux/irqflags.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/irqflags.h" 1
# 11 "/usr/src/linux-2.6/arch/x86/include/asm/irqflags.h"
static inline __attribute__((no_instrument_function)) unsigned long native_=
save_fl(void)
{
 unsigned long flags;






 asm volatile("# __raw_save_flags\n\t"
       "pushf ; pop %0"
       : "=3Drm" (flags)
       :
       : "memory");

 return flags;
}

static inline __attribute__((no_instrument_function)) void native_restore_f=
l(unsigned long flags)
{
 asm volatile("push %0 ; popf"
       :
       :"g" (flags)
       :"memory", "cc");
}

static inline __attribute__((no_instrument_function)) void native_irq_disab=
le(void)
{
 asm volatile("cli": : :"memory");
}

static inline __attribute__((no_instrument_function)) void native_irq_enabl=
e(void)
{
 asm volatile("sti": : :"memory");
}

static inline __attribute__((no_instrument_function)) void native_safe_halt=
(void)
{
 asm volatile("sti; hlt": : :"memory");
}

static inline __attribute__((no_instrument_function)) void native_halt(void)
{
 asm volatile("hlt": : :"memory");
}
# 65 "/usr/src/linux-2.6/arch/x86/include/asm/irqflags.h"
static inline __attribute__((no_instrument_function)) __attribute__((no_ins=
trument_function)) unsigned long arch_local_save_flags(void)
{
 return native_save_fl();
}

static inline __attribute__((no_instrument_function)) __attribute__((no_ins=
trument_function)) void arch_local_irq_restore(unsigned long flags)
{
 native_restore_fl(flags);
}

static inline __attribute__((no_instrument_function)) __attribute__((no_ins=
trument_function)) void arch_local_irq_disable(void)
{
 native_irq_disable();
}

static inline __attribute__((no_instrument_function)) __attribute__((no_ins=
trument_function)) void arch_local_irq_enable(void)
{
 native_irq_enable();
}





static inline __attribute__((no_instrument_function)) void arch_safe_halt(v=
oid)
{
 native_safe_halt();
}





static inline __attribute__((no_instrument_function)) void halt(void)
{
 native_halt();
}




static inline __attribute__((no_instrument_function)) __attribute__((no_ins=
trument_function)) unsigned long arch_local_irq_save(void)
{
 unsigned long flags =3D arch_local_save_flags();
 arch_local_irq_disable();
 return flags;
}
# 155 "/usr/src/linux-2.6/arch/x86/include/asm/irqflags.h"
static inline __attribute__((no_instrument_function)) int arch_irqs_disable=
d_flags(unsigned long flags)
{
 return !(flags & ((1UL) << (9)));
}

static inline __attribute__((no_instrument_function)) int arch_irqs_disable=
d(void)
{
 unsigned long flags =3D arch_local_save_flags();

 return arch_irqs_disabled_flags(flags);
}
# 16 "/usr/src/linux-2.6/include/linux/irqflags.h" 2
# 33 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h" 2
# 47 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
static inline __attribute__((no_instrument_function)) void *current_text_ad=
dr(void)
{
 void *pc;

 asm volatile("mov $1f, %0; 1:":"=3Dr" (pc));

 return pc;
}
# 64 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
enum tlb_infos {
 ENTRIES,
 NR_INFO
};

extern u16 __attribute__((__section__(".data..read_mostly"))) tlb_lli_4k[NR=
_INFO];
extern u16 __attribute__((__section__(".data..read_mostly"))) tlb_lli_2m[NR=
_INFO];
extern u16 __attribute__((__section__(".data..read_mostly"))) tlb_lli_4m[NR=
_INFO];
extern u16 __attribute__((__section__(".data..read_mostly"))) tlb_lld_4k[NR=
_INFO];
extern u16 __attribute__((__section__(".data..read_mostly"))) tlb_lld_2m[NR=
_INFO];
extern u16 __attribute__((__section__(".data..read_mostly"))) tlb_lld_4m[NR=
_INFO];
extern s8 __attribute__((__section__(".data..read_mostly"))) tlb_flushall_s=
hift;







struct cpuinfo_x86 {
 __u8 x86;
 __u8 x86_vendor;
 __u8 x86_model;
 __u8 x86_mask;

 char wp_works_ok;


 char rfu;
 char pad0;
 char pad1;




 __u8 x86_virt_bits;
 __u8 x86_phys_bits;

 __u8 x86_coreid_bits;

 __u32 extended_cpuid_level;

 int cpuid_level;
 __u32 x86_capability[10 + 1];
 char x86_vendor_id[16];
 char x86_model_id[64];

 int x86_cache_size;
 int x86_cache_alignment;
 int x86_power;
 unsigned long loops_per_jiffy;

 u16 x86_max_cores;
 u16 apicid;
 u16 initial_apicid;
 u16 x86_clflush_size;

 u16 booted_cores;

 u16 phys_proc_id;

 u16 cpu_core_id;

 u8 compute_unit_id;

 u16 cpu_index;
 u32 microcode;
} __attribute__((__aligned__((1 << (6)))));
# 147 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
extern struct cpuinfo_x86 boot_cpu_data;
extern struct cpuinfo_x86 new_cpu_data;

extern struct tss_struct doublefault_tss;
extern __u32 cpu_caps_cleared[10];
extern __u32 cpu_caps_set[10];
# 162 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
extern const struct seq_operations cpuinfo_op;



extern void cpu_detect(struct cpuinfo_x86 *c);
extern void fpu_detect(struct cpuinfo_x86 *c);

extern void early_cpu_init(void);
extern void identify_boot_cpu(void);
extern void identify_secondary_cpu(struct cpuinfo_x86 *);
extern void print_cpu_info(struct cpuinfo_x86 *);
void print_cpu_msr(struct cpuinfo_x86 *);
extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
extern void init_amd_cacheinfo(struct cpuinfo_x86 *c);

extern void detect_extended_topology(struct cpuinfo_x86 *c);
extern void detect_ht(struct cpuinfo_x86 *c);


extern int have_cpuid_p(void);






static inline __attribute__((no_instrument_function)) void native_cpuid(uns=
igned int *eax, unsigned int *ebx,
    unsigned int *ecx, unsigned int *edx)
{

 asm volatile("cpuid"
     : "=3Da" (*eax),
       "=3Db" (*ebx),
       "=3Dc" (*ecx),
       "=3Dd" (*edx)
     : "0" (*eax), "2" (*ecx)
     : "memory");
}

static inline __attribute__((no_instrument_function)) void load_cr3(pgd_t *=
pgdir)
{
 write_cr3((((unsigned long)(pgdir)) - ((unsigned long)(0xC0000000UL))));
}



struct x86_hw_tss {
 unsigned short back_link, __blh;
 unsigned long sp0;
 unsigned short ss0, __ss0h;
 unsigned long sp1;

 unsigned short ss1, __ss1h;
 unsigned long sp2;
 unsigned short ss2, __ss2h;
 unsigned long __cr3;
 unsigned long ip;
 unsigned long flags;
 unsigned long ax;
 unsigned long cx;
 unsigned long dx;
 unsigned long bx;
 unsigned long sp;
 unsigned long bp;
 unsigned long si;
 unsigned long di;
 unsigned short es, __esh;
 unsigned short cs, __csh;
 unsigned short ss, __ssh;
 unsigned short ds, __dsh;
 unsigned short fs, __fsh;
 unsigned short gs, __gsh;
 unsigned short ldt, __ldth;
 unsigned short trace;
 unsigned short io_bitmap_base;

} __attribute__((packed));
# 265 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
struct tss_struct {



 struct x86_hw_tss x86_tss;







 unsigned long io_bitmap[((65536/8)/sizeof(long)) + 1];




 unsigned long stack[64];

} __attribute__((__aligned__((1 << (6)))));

extern __attribute__((section(".data" ""))) __typeof__(struct tss_struct) i=
nit_tss ;




struct orig_ist {
 unsigned long ist[7];
};



struct i387_fsave_struct {
 u32 cwd;
 u32 swd;
 u32 twd;
 u32 fip;
 u32 fcs;
 u32 foo;
 u32 fos;


 u32 st_space[20];


 u32 status;
};

struct i387_fxsave_struct {
 u16 cwd;
 u16 swd;
 u16 twd;
 u16 fop;
 union {
  struct {
   u64 rip;
   u64 rdp;
  };
  struct {
   u32 fip;
   u32 fcs;
   u32 foo;
   u32 fos;
  };
 };
 u32 mxcsr;
 u32 mxcsr_mask;


 u32 st_space[32];


 u32 xmm_space[64];

 u32 padding[12];

 union {
  u32 padding1[12];
  u32 sw_reserved[12];
 };

} __attribute__((aligned(16)));

struct i387_soft_struct {
 u32 cwd;
 u32 swd;
 u32 twd;
 u32 fip;
 u32 fcs;
 u32 foo;
 u32 fos;

 u32 st_space[20];
 u8 ftop;
 u8 changed;
 u8 lookahead;
 u8 no_update;
 u8 rm;
 u8 alimit;
 struct math_emu_info *info;
 u32 entry_eip;
};

struct ymmh_struct {

 u32 ymmh_space[64];
};

struct xsave_hdr_struct {
 u64 xstate_bv;
 u64 reserved1[2];
 u64 reserved2[5];
} __attribute__((packed));

struct xsave_struct {
 struct i387_fxsave_struct i387;
 struct xsave_hdr_struct xsave_hdr;
 struct ymmh_struct ymmh;

} __attribute__ ((packed, aligned (64)));

union thread_xstate {
 struct i387_fsave_struct fsave;
 struct i387_fxsave_struct fxsave;
 struct i387_soft_struct soft;
 struct xsave_struct xsave;
};

struct fpu {
 unsigned int last_cpu;
 unsigned int has_fpu;
 union thread_xstate *state;
};
# 437 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
extern unsigned int xstate_size;
extern void free_thread_xstate(struct task_struct *);
extern struct kmem_cache *task_xstate_cachep;

struct perf_event;

struct thread_struct {

 struct desc_struct tls_array[3];
 unsigned long sp0;
 unsigned long sp;

 unsigned long sysenter_cs;
# 458 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
 unsigned long ip;




 unsigned long gs;

 struct perf_event *ptrace_bps[4];

 unsigned long debugreg6;

 unsigned long ptrace_dr7;

 unsigned long cr2;
 unsigned long trap_nr;
 unsigned long error_code;

 struct fpu fpu;


 struct vm86_struct *vm86_info;
 unsigned long screen_bitmap;
 unsigned long v86flags;
 unsigned long v86mask;
 unsigned long saved_sp0;
 unsigned int saved_fs;
 unsigned int saved_gs;


 unsigned long *io_bitmap_ptr;
 unsigned long iopl;

 unsigned io_bitmap_max;
};




static inline __attribute__((no_instrument_function)) void native_set_iopl_=
mask(unsigned mask)
{

 unsigned int reg;

 asm volatile ("pushfl;"
        "popl %0;"
        "andl %1, %0;"
        "orl %2, %0;"
        "pushl %0;"
        "popfl"
        : "=3D&r" (reg)
        : "i" (~((3UL) << 12)), "r" (mask));

}

static inline __attribute__((no_instrument_function)) void
native_load_sp0(struct tss_struct *tss, struct thread_struct *thread)
{
 tss->x86_tss.sp0 =3D thread->sp0;


 if (__builtin_expect(!!(tss->x86_tss.ss1 !=3D thread->sysenter_cs), 0)) {
  tss->x86_tss.ss1 =3D thread->sysenter_cs;
  wrmsr(0x00000174, thread->sysenter_cs, 0);
 }

}

static inline __attribute__((no_instrument_function)) void native_swapgs(vo=
id)
{



}







static inline __attribute__((no_instrument_function)) void load_sp0(struct =
tss_struct *tss,
       struct thread_struct *thread)
{
 native_load_sp0(tss, thread);
}
# 553 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
extern unsigned long mmu_cr4_features;
extern u32 *trampoline_cr4_features;

static inline __attribute__((no_instrument_function)) void set_in_cr4(unsig=
ned long mask)
{
 unsigned long cr4;

 mmu_cr4_features |=3D mask;
 if (trampoline_cr4_features)
  *trampoline_cr4_features =3D mmu_cr4_features;
 cr4 =3D read_cr4();
 cr4 |=3D mask;
 write_cr4(cr4);
}

static inline __attribute__((no_instrument_function)) void clear_in_cr4(uns=
igned long mask)
{
 unsigned long cr4;

 mmu_cr4_features &=3D ~mask;
 if (trampoline_cr4_features)
  *trampoline_cr4_features =3D mmu_cr4_features;
 cr4 =3D read_cr4();
 cr4 &=3D ~mask;
 write_cr4(cr4);
}

typedef struct {
 unsigned long seg;
} mm_segment_t;



extern void release_thread(struct task_struct *);

unsigned long get_wchan(struct task_struct *p);






static inline __attribute__((no_instrument_function)) void cpuid(unsigned i=
nt op,
    unsigned int *eax, unsigned int *ebx,
    unsigned int *ecx, unsigned int *edx)
{
 *eax =3D op;
 *ecx =3D 0;
 native_cpuid(eax, ebx, ecx, edx);
}


static inline __attribute__((no_instrument_function)) void cpuid_count(unsi=
gned int op, int count,
          unsigned int *eax, unsigned int *ebx,
          unsigned int *ecx, unsigned int *edx)
{
 *eax =3D op;
 *ecx =3D count;
 native_cpuid(eax, ebx, ecx, edx);
}




static inline __attribute__((no_instrument_function)) unsigned int cpuid_ea=
x(unsigned int op)
{
 unsigned int eax, ebx, ecx, edx;

 cpuid(op, &eax, &ebx, &ecx, &edx);

 return eax;
}

static inline __attribute__((no_instrument_function)) unsigned int cpuid_eb=
x(unsigned int op)
{
 unsigned int eax, ebx, ecx, edx;

 cpuid(op, &eax, &ebx, &ecx, &edx);

 return ebx;
}

static inline __attribute__((no_instrument_function)) unsigned int cpuid_ec=
x(unsigned int op)
{
 unsigned int eax, ebx, ecx, edx;

 cpuid(op, &eax, &ebx, &ecx, &edx);

 return ecx;
}

static inline __attribute__((no_instrument_function)) unsigned int cpuid_ed=
x(unsigned int op)
{
 unsigned int eax, ebx, ecx, edx;

 cpuid(op, &eax, &ebx, &ecx, &edx);

 return edx;
}


static inline __attribute__((no_instrument_function)) void rep_nop(void)
{
 asm volatile("rep; nop" ::: "memory");
}

static inline __attribute__((no_instrument_function)) void cpu_relax(void)
{
 rep_nop();
}


static inline __attribute__((no_instrument_function)) void sync_core(void)
{
 int tmp;
# 687 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
 asm volatile("cpuid"
       : "=3Da" (tmp)
       : "0" (1)
       : "ebx", "ecx", "edx", "memory");

}

static inline __attribute__((no_instrument_function)) void __monitor(const =
void *eax, unsigned long ecx,
        unsigned long edx)
{

 asm volatile(".byte 0x0f, 0x01, 0xc8;"
       :: "a" (eax), "c" (ecx), "d"(edx));
}

static inline __attribute__((no_instrument_function)) void __mwait(unsigned=
 long eax, unsigned long ecx)
{

 asm volatile(".byte 0x0f, 0x01, 0xc9;"
       :: "a" (eax), "c" (ecx));
}

static inline __attribute__((no_instrument_function)) void __sti_mwait(unsi=
gned long eax, unsigned long ecx)
{
 do { } while (0);

 asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
       :: "a" (eax), "c" (ecx));
}

extern void select_idle_routine(const struct cpuinfo_x86 *c);
extern void init_amd_e400_c1e_mask(void);

extern unsigned long boot_option_idle_override;
extern bool amd_e400_c1e_detected;

enum idle_boot_override {IDLE_NO_OVERRIDE=3D0, IDLE_HALT, IDLE_NOMWAIT,
    IDLE_POLL};

extern void enable_sep_cpu(void);
extern int sysenter_setup(void);

extern void early_trap_init(void);
void early_trap_pf_init(void);


extern struct desc_ptr early_gdt_descr;

extern void cpu_set_gdt(int);
extern void switch_to_new_gdt(int);
extern void load_percpu_segment(int);
extern void cpu_init(void);

static inline __attribute__((no_instrument_function)) unsigned long get_deb=
ugctlmsr(void)
{
 unsigned long debugctlmsr =3D 0;





 ((debugctlmsr) =3D native_read_msr((0x000001d9)));

 return debugctlmsr;
}

static inline __attribute__((no_instrument_function)) void update_debugctlm=
sr(unsigned long debugctlmsr)
{




 native_write_msr((0x000001d9), (u32)((u64)(debugctlmsr)), (u32)((u64)(debu=
gctlmsr) >> 32));
}

extern void set_task_blockstep(struct task_struct *task, bool on);





extern unsigned int machine_id;
extern unsigned int machine_submodel_id;
extern unsigned int BIOS_revision;


extern int bootloader_type;
extern int bootloader_version;

extern char ignore_fpu_irq;
# 795 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
static inline __attribute__((no_instrument_function)) void prefetch(const v=
oid *x)
{
 asm volatile ("661:\n\t" ".byte " "0x8d,0x74,0x26,0x00" "\n" "\n662:\n" ".=
pushsection .altinstructions,\"a\"\n" " .long 661b - .\n" " .long " "663""1=
""f - .\n" " .word " "(0*32+25)" "\n" " .byte " "662b-661b" "\n" " .byte " =
"664""1""f-""663""1""f" "\n" ".popsection\n" ".pushsection .discard,\"aw\",=
@progbits\n" " .byte 0xff + (" "664""1""f-""663""1""f" ") - (" "662b-661b" =
")\n" ".popsection\n" ".pushsection .altinstr_replacement, \"ax\"\n" "663""=
1"":\n\t" "prefetchnta (%1)" "\n" "664""1" ":\n\t" ".popsection" : : "i" (0=
), "r" (x))


             ;
}






static inline __attribute__((no_instrument_function)) void prefetchw(const =
void *x)
{
 asm volatile ("661:\n\t" ".byte " "0x8d,0x74,0x26,0x00" "\n" "\n662:\n" ".=
pushsection .altinstructions,\"a\"\n" " .long 661b - .\n" " .long " "663""1=
""f - .\n" " .word " "(1*32+31)" "\n" " .byte " "662b-661b" "\n" " .byte " =
"664""1""f-""663""1""f" "\n" ".popsection\n" ".pushsection .discard,\"aw\",=
@progbits\n" " .byte 0xff + (" "664""1""f-""663""1""f" ") - (" "662b-661b" =
")\n" ".popsection\n" ".pushsection .altinstr_replacement, \"ax\"\n" "663""=
1"":\n\t" "prefetchw (%1)" "\n" "664""1" ":\n\t" ".popsection" : : "i" (0),=
 "r" (x))


             ;
}

static inline __attribute__((no_instrument_function)) void spin_lock_prefet=
ch(const void *x)
{
 prefetchw(x);
}
# 853 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
extern unsigned long thread_saved_pc(struct task_struct *tsk);
# 925 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
            unsigned long new_sp);
# 940 "/usr/src/linux-2.6/arch/x86/include/asm/processor.h"
extern int get_tsc_mode(unsigned long adr);
extern int set_tsc_mode(unsigned int val);

extern u16 amd_get_nb_id(int cpu);

static inline __attribute__((no_instrument_function)) uint32_t hypervisor_c=
puid_base(const char *sig, uint32_t leaves)
{
 uint32_t base, eax, signature[3];

 for (base =3D 0x40000000; base < 0x40010000; base +=3D 0x100) {
  cpuid(base, &eax, &signature[0], &signature[1], &signature[2]);

  if (!__builtin_memcmp(sig, signature, 12) &&
      (leaves =3D=3D 0 || ((eax - base) >=3D leaves)))
   return base;
 }

 return 0;
}

extern unsigned long arch_align_stack(unsigned long sp);
extern void free_init_pages(char *what, unsigned long begin, unsigned long =
end);

void default_idle(void);






void stop_this_cpu(void *dummy);
void df_debug(struct pt_regs *regs, long error_code);
# 23 "/usr/src/linux-2.6/arch/x86/include/asm/thread_info.h" 2
# 1 "/usr/src/linux-2.6/include/linux/atomic.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h" 1







# 1 "/usr/src/linux-2.6/arch/x86/include/asm/cmpxchg.h" 1
# 11 "/usr/src/linux-2.6/arch/x86/include/asm/cmpxchg.h"
extern void __xchg_wrong_size(void)
 __attribute__((error("Bad argument size for xchg")));
extern void __cmpxchg_wrong_size(void)
 __attribute__((error("Bad argument size for cmpxchg")));
extern void __xadd_wrong_size(void)
 __attribute__((error("Bad argument size for xadd")));
extern void __add_wrong_size(void)
 __attribute__((error("Bad argument size for add")));
# 141 "/usr/src/linux-2.6/arch/x86/include/asm/cmpxchg.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/cmpxchg_32.h" 1
# 23 "/usr/src/linux-2.6/arch/x86/include/asm/cmpxchg_32.h"
static inline __attribute__((no_instrument_function)) void set_64bit(volati=
le u64 *ptr, u64 value)
{
 u32 low =3D value;
 u32 high =3D value >> 32;
 u64 prev =3D *ptr;

 asm volatile("\n1:\t"
       "" "cmpxchg8b %0\n\t"
       "jnz 1b"
       : "=3Dm" (*ptr), "+A" (prev)
       : "b" (low), "c" (high)
       : "memory");
}
# 48 "/usr/src/linux-2.6/arch/x86/include/asm/cmpxchg_32.h"
static inline __attribute__((no_instrument_function)) u64 __cmpxchg64(volat=
ile u64 *ptr, u64 old, u64 new)
{
 u64 prev;
 asm volatile("" "cmpxchg8b %1"
       : "=3DA" (prev),
         "+m" (*ptr)
       : "b" ((u32)new),
         "c" ((u32)(new >> 32)),
         "0" (old)
       : "memory");
 return prev;
}

static inline __attribute__((no_instrument_function)) u64 __cmpxchg64_local=
(volatile u64 *ptr, u64 old, u64 new)
{
 u64 prev;
 asm volatile("cmpxchg8b %1"
       : "=3DA" (prev),
         "+m" (*ptr)
       : "b" ((u32)new),
         "c" ((u32)(new >> 32)),
         "0" (old)
       : "memory");
 return prev;
}
# 142 "/usr/src/linux-2.6/arch/x86/include/asm/cmpxchg.h" 2
# 9 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h" 2
# 24 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_read(const=
 atomic_t *v)
{
 return (*(volatile int *)&(v)->counter);
}
# 36 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) void atomic_set(atomi=
c_t *v, int i)
{
 v->counter =3D i;
}
# 48 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) void atomic_add(int i=
, atomic_t *v)
{
 asm volatile("" "addl %1,%0"
       : "+m" (v->counter)
       : "ir" (i));
}
# 62 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) void atomic_sub(int i=
, atomic_t *v)
{
 asm volatile("" "subl %1,%0"
       : "+m" (v->counter)
       : "ir" (i));
}
# 78 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_sub_and_te=
st(int i, atomic_t *v)
{
 do { asm volatile goto ("" "subl" " %1, " "%0" "; j" "e" " %l[cc_label]" :=
 : "m" (v->counter), "er" (i) : "memory" : cc_label); return 0; cc_label: r=
eturn 1; } while (0);
}







static inline __attribute__((no_instrument_function)) void atomic_inc(atomi=
c_t *v)
{
 asm volatile("" "incl %0"
       : "+m" (v->counter));
}







static inline __attribute__((no_instrument_function)) void atomic_dec(atomi=
c_t *v)
{
 asm volatile("" "decl %0"
       : "+m" (v->counter));
}
# 115 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_dec_and_te=
st(atomic_t *v)
{
 do { asm volatile goto ("" "decl" " " "%0" "; j" "e" " %l[cc_label]" : : "=
m" (v->counter) : "memory" : cc_label); return 0; cc_label: return 1; } whi=
le (0);
}
# 128 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_inc_and_te=
st(atomic_t *v)
{
 do { asm volatile goto ("" "incl" " " "%0" "; j" "e" " %l[cc_label]" : : "=
m" (v->counter) : "memory" : cc_label); return 0; cc_label: return 1; } whi=
le (0);
}
# 142 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_add_negati=
ve(int i, atomic_t *v)
{
 do { asm volatile goto ("" "addl" " %1, " "%0" "; j" "s" " %l[cc_label]" :=
 : "m" (v->counter), "er" (i) : "memory" : cc_label); return 0; cc_label: r=
eturn 1; } while (0);
}
# 154 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_add_return=
(int i, atomic_t *v)
{
 return i + ({ __typeof__ (*(((&v->counter)))) __ret =3D (((i))); switch (s=
izeof(*(((&v->counter))))) { case 1: asm volatile ("" "xadd" "b %b0, %1\n" =
: "+q" (__ret), "+m" (*(((&v->counter)))) : : "memory", "cc"); break; case =
2: asm volatile ("" "xadd" "w %w0, %1\n" : "+r" (__ret), "+m" (*(((&v->coun=
ter)))) : : "memory", "cc"); break; case 4: asm volatile ("" "xadd" "l %0, =
%1\n" : "+r" (__ret), "+m" (*(((&v->counter)))) : : "memory", "cc"); break;=
 case -1: asm volatile ("" "xadd" "q %q0, %1\n" : "+r" (__ret), "+m" (*(((&=
v->counter)))) : : "memory", "cc"); break; default: __xadd_wrong_size(); } =
__ret; });
}
# 166 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_sub_return=
(int i, atomic_t *v)
{
 return atomic_add_return(-i, v);
}




static inline __attribute__((no_instrument_function)) int atomic_cmpxchg(at=
omic_t *v, int old, int new)
{
 return ({ __typeof__(*((&v->counter))) __ret; __typeof__(*((&v->counter)))=
 __old =3D ((old)); __typeof__(*((&v->counter))) __new =3D ((new)); switch =
((sizeof(*(&v->counter)))) { case 1: { volatile u8 *__ptr =3D (volatile u8 =
*)((&v->counter)); asm volatile("" "cmpxchgb %2,%1" : "=3Da" (__ret), "+m" =
(*__ptr) : "q" (__new), "0" (__old) : "memory"); break; } case 2: { volatil=
e u16 *__ptr =3D (volatile u16 *)((&v->counter)); asm volatile("" "cmpxchgw=
 %2,%1" : "=3Da" (__ret), "+m" (*__ptr) : "r" (__new), "0" (__old) : "memor=
y"); break; } case 4: { volatile u32 *__ptr =3D (volatile u32 *)((&v->count=
er)); asm volatile("" "cmpxchgl %2,%1" : "=3Da" (__ret), "+m" (*__ptr) : "r=
" (__new), "0" (__old) : "memory"); break; } case -1: { volatile u64 *__ptr=
 =3D (volatile u64 *)((&v->counter)); asm volatile("" "cmpxchgq %2,%1" : "=
=3Da" (__ret), "+m" (*__ptr) : "r" (__new), "0" (__old) : "memory"); break;=
 } default: __cmpxchg_wrong_size(); } __ret; });
}

static inline __attribute__((no_instrument_function)) int atomic_xchg(atomi=
c_t *v, int new)
{
 return ({ __typeof__ (*((&v->counter))) __ret =3D ((new)); switch (sizeof(=
*((&v->counter)))) { case 1: asm volatile ("" "xchg" "b %b0, %1\n" : "+q" (=
__ret), "+m" (*((&v->counter))) : : "memory", "cc"); break; case 2: asm vol=
atile ("" "xchg" "w %w0, %1\n" : "+r" (__ret), "+m" (*((&v->counter))) : : =
"memory", "cc"); break; case 4: asm volatile ("" "xchg" "l %0, %1\n" : "+r"=
 (__ret), "+m" (*((&v->counter))) : : "memory", "cc"); break; case -1: asm =
volatile ("" "xchg" "q %q0, %1\n" : "+r" (__ret), "+m" (*((&v->counter))) :=
 : "memory", "cc"); break; default: __xchg_wrong_size(); } __ret; });
}
# 193 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) int __atomic_add_unle=
ss(atomic_t *v, int a, int u)
{
 int c, old;
 c =3D atomic_read(v);
 for (;;) {
  if (__builtin_expect(!!(c =3D=3D (u)), 0))
   break;
  old =3D atomic_cmpxchg((v), c, c + (a));
  if (__builtin_expect(!!(old =3D=3D c), 1))
   break;
  c =3D old;
 }
 return c;
}
# 215 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
static inline __attribute__((no_instrument_function)) short int atomic_inc_=
short(short int *v)
{
 asm("" "addw $1, %0" : "+m" (*v));
 return *v;
}
# 253 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h" 1
# 11 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
typedef struct {
 u64 __attribute__((aligned(8))) counter;
} atomic64_t;
# 48 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
void atomic64_read_cx8(atomic64_t *, ...);
void atomic64_set_cx8(atomic64_t *, ...);
void atomic64_xchg_cx8(atomic64_t *, ...);
void atomic64_add_return_cx8(atomic64_t *, ...);
void atomic64_sub_return_cx8(atomic64_t *, ...);
void atomic64_inc_return_cx8(atomic64_t *, ...);
void atomic64_dec_return_cx8(atomic64_t *, ...);
void atomic64_dec_if_positive_cx8(atomic64_t *, ...);
void atomic64_inc_not_zero_cx8(atomic64_t *, ...);
void atomic64_add_unless_cx8(atomic64_t *, ...);
# 74 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) long long atomic64_cm=
pxchg(atomic64_t *v, long long o, long long n)
{
 return ((__typeof__(*(&v->counter)))__cmpxchg64((&v->counter), (unsigned l=
ong long)(o), (unsigned long long)(n)));
}
# 87 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) long long atomic64_xc=
hg(atomic64_t *v, long long n)
{
 long long o;
 unsigned high =3D (unsigned)(n >> 32);
 unsigned low =3D (unsigned)n;
 asm volatile("call %P[func]" : "=3D&A" (o) : [func] "i" (atomic64_xchg_cx8=
), "S" (v), "b" (low), "c" (high) : "memory")

                   ;
 return o;
}
# 105 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) void atomic64_set(ato=
mic64_t *v, long long i)
{
 unsigned high =3D (unsigned)(i >> 32);
 unsigned low =3D (unsigned)i;
 asm volatile("call %P[func]" : : [func] "i" (atomic64_set_cx8), "S" (v), "=
b" (low), "c" (high) : "eax", "edx", "memory")

                                 ;
}







static inline __attribute__((no_instrument_function)) long long atomic64_re=
ad(const atomic64_t *v)
{
 long long r;
 asm volatile("call %P[func]" : "=3D&A" (r) : [func] "i" (atomic64_read_cx8=
), "c" (v) : "memory");
 return r;
 }
# 134 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) long long atomic64_ad=
d_return(long long i, atomic64_t *v)
{
 asm volatile("call %P[func]" : "+A" (i), "+c" (v) : [func] "i" (atomic64_a=
dd_return_cx8), "i" (0) : "memory")

                                       ;
 return i;
}




static inline __attribute__((no_instrument_function)) long long atomic64_su=
b_return(long long i, atomic64_t *v)
{
 asm volatile("call %P[func]" : "+A" (i), "+c" (v) : [func] "i" (atomic64_s=
ub_return_cx8), "i" (0) : "memory")

                                       ;
 return i;
}

static inline __attribute__((no_instrument_function)) long long atomic64_in=
c_return(atomic64_t *v)
{
 long long a;
 asm volatile("call %P[func]" : "=3D&A" (a) : [func] "i" (atomic64_inc_retu=
rn_cx8), "S" (v) : "memory", "ecx")
                                  ;
 return a;
}

static inline __attribute__((no_instrument_function)) long long atomic64_de=
c_return(atomic64_t *v)
{
 long long a;
 asm volatile("call %P[func]" : "=3D&A" (a) : [func] "i" (atomic64_dec_retu=
rn_cx8), "S" (v) : "memory", "ecx")
                                  ;
 return a;
}
# 176 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) long long atomic64_ad=
d(long long i, atomic64_t *v)
{
 asm volatile("call %P[func]" : "+A" (i), "+c" (v) : [func] "i" (atomic64_a=
dd_return_cx8), "i" (0) : "memory")

                                         ;
 return i;
}
# 191 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) long long atomic64_su=
b(long long i, atomic64_t *v)
{
 asm volatile("call %P[func]" : "+A" (i), "+c" (v) : [func] "i" (atomic64_s=
ub_return_cx8), "i" (0) : "memory")

                                         ;
 return i;
}
# 208 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) int atomic64_sub_and_=
test(long long i, atomic64_t *v)
{
 return atomic64_sub_return(i, v) =3D=3D 0;
}







static inline __attribute__((no_instrument_function)) void atomic64_inc(ato=
mic64_t *v)
{
 asm volatile("call %P[func]" : : [func] "i" (atomic64_inc_return_cx8), "S"=
 (v) : "memory", "eax", "ecx", "edx")
                                                  ;
}







static inline __attribute__((no_instrument_function)) void atomic64_dec(ato=
mic64_t *v)
{
 asm volatile("call %P[func]" : : [func] "i" (atomic64_dec_return_cx8), "S"=
 (v) : "memory", "eax", "ecx", "edx")
                                                  ;
}
# 245 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) int atomic64_dec_and_=
test(atomic64_t *v)
{
 return atomic64_dec_return(v) =3D=3D 0;
}
# 258 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) int atomic64_inc_and_=
test(atomic64_t *v)
{
 return atomic64_inc_return(v) =3D=3D 0;
}
# 272 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) int atomic64_add_nega=
tive(long long i, atomic64_t *v)
{
 return atomic64_add_return(i, v) < 0;
}
# 286 "/usr/src/linux-2.6/arch/x86/include/asm/atomic64_32.h"
static inline __attribute__((no_instrument_function)) int atomic64_add_unle=
ss(atomic64_t *v, long long a, long long u)
{
 unsigned low =3D (unsigned)u;
 unsigned high =3D (unsigned)(u >> 32);
 asm volatile("call %P[func]" : "+A" (a), "+c" (low), "+D" (high) : [func] =
"i" (atomic64_add_unless_cx8), "S" (v) : "memory")

                           ;
 return (int)a;
}


static inline __attribute__((no_instrument_function)) int atomic64_inc_not_=
zero(atomic64_t *v)
{
 int r;
 asm volatile("call %P[func]" : "=3D&a" (r) : [func] "i" (atomic64_inc_not_=
zero_cx8), "S" (v) : "ecx", "edx", "memory")
                                         ;
 return r;
}

static inline __attribute__((no_instrument_function)) long long atomic64_de=
c_if_positive(atomic64_t *v)
{
 long long r;
 asm volatile("call %P[func]" : "=3D&A" (r) : [func] "i" (atomic64_dec_if_p=
ositive_cx8), "S" (v) : "ecx", "memory")
                                  ;
 return r;
}
# 254 "/usr/src/linux-2.6/arch/x86/include/asm/atomic.h" 2
# 5 "/usr/src/linux-2.6/include/linux/atomic.h" 2
# 15 "/usr/src/linux-2.6/include/linux/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_add_unless=
(atomic_t *v, int a, int u)
{
 return __atomic_add_unless(v, a, u) !=3D u;
}
# 44 "/usr/src/linux-2.6/include/linux/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_inc_not_ze=
ro_hint(atomic_t *v, int hint)
{
 int val, c =3D hint;


 if (!hint)
  return atomic_add_unless((v), 1, 0);

 do {
  val =3D atomic_cmpxchg(v, c, c + 1);
  if (val =3D=3D c)
   return 1;
  c =3D val;
 } while (c);

 return 0;
}



static inline __attribute__((no_instrument_function)) int atomic_inc_unless=
_negative(atomic_t *p)
{
 int v, v1;
 for (v =3D 0; v >=3D 0; v =3D v1) {
  v1 =3D atomic_cmpxchg(p, v, v + 1);
  if (__builtin_expect(!!(v1 =3D=3D v), 1))
   return 1;
 }
 return 0;
}



static inline __attribute__((no_instrument_function)) int atomic_dec_unless=
_positive(atomic_t *p)
{
 int v, v1;
 for (v =3D 0; v <=3D 0; v =3D v1) {
  v1 =3D atomic_cmpxchg(p, v, v - 1);
  if (__builtin_expect(!!(v1 =3D=3D v), 1))
   return 1;
 }
 return 0;
}
# 97 "/usr/src/linux-2.6/include/linux/atomic.h"
static inline __attribute__((no_instrument_function)) int atomic_dec_if_pos=
itive(atomic_t *v)
{
 int c, old, dec;
 c =3D atomic_read(v);
 for (;;) {
  dec =3D c - 1;
  if (__builtin_expect(!!(dec < 0), 0))
   break;
  old =3D atomic_cmpxchg((v), c, dec);
  if (__builtin_expect(!!(old =3D=3D c), 1))
   break;
  c =3D old;
 }
 return dec;
}



static inline __attribute__((no_instrument_function)) void atomic_or(int i,=
 atomic_t *v)
{
 int old;
 int new;

 do {
  old =3D atomic_read(v);
  new =3D old | i;
 } while (atomic_cmpxchg(v, old, new) !=3D old);
}


# 1 "/usr/src/linux-2.6/include/asm-generic/atomic-long.h" 1
# 141 "/usr/src/linux-2.6/include/asm-generic/atomic-long.h"
typedef atomic_t atomic_long_t;


static inline __attribute__((no_instrument_function)) long atomic_long_read=
(atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 return (long)atomic_read(v);
}

static inline __attribute__((no_instrument_function)) void atomic_long_set(=
atomic_long_t *l, long i)
{
 atomic_t *v =3D (atomic_t *)l;

 atomic_set(v, i);
}

static inline __attribute__((no_instrument_function)) void atomic_long_inc(=
atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 atomic_inc(v);
}

static inline __attribute__((no_instrument_function)) void atomic_long_dec(=
atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 atomic_dec(v);
}

static inline __attribute__((no_instrument_function)) void atomic_long_add(=
long i, atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 atomic_add(i, v);
}

static inline __attribute__((no_instrument_function)) void atomic_long_sub(=
long i, atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 atomic_sub(i, v);
}

static inline __attribute__((no_instrument_function)) int atomic_long_sub_a=
nd_test(long i, atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 return atomic_sub_and_test(i, v);
}

static inline __attribute__((no_instrument_function)) int atomic_long_dec_a=
nd_test(atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 return atomic_dec_and_test(v);
}

static inline __attribute__((no_instrument_function)) int atomic_long_inc_a=
nd_test(atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 return atomic_inc_and_test(v);
}

static inline __attribute__((no_instrument_function)) int atomic_long_add_n=
egative(long i, atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 return atomic_add_negative(i, v);
}

static inline __attribute__((no_instrument_function)) long atomic_long_add_=
return(long i, atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 return (long)atomic_add_return(i, v);
}

static inline __attribute__((no_instrument_function)) long atomic_long_sub_=
return(long i, atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 return (long)atomic_sub_return(i, v);
}

static inline __attribute__((no_instrument_function)) long atomic_long_inc_=
return(atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 return (long)(atomic_add_return(1, v));
}

static inline __attribute__((no_instrument_function)) long atomic_long_dec_=
return(atomic_long_t *l)
{
 atomic_t *v =3D (atomic_t *)l;

 return (long)(atomic_sub_return(1, v));
}

static inline __attribute__((no_instrument_function)) long atomic_long_add_=
unless(atomic_long_t *l, long a, long u)
{
 atomic_t *v =3D (atomic_t *)l;

 return (long)atomic_add_unless(v, a, u);
}
# 128 "/usr/src/linux-2.6/include/linux/atomic.h" 2
# 24 "/usr/src/linux-2.6/arch/x86/include/asm/thread_info.h" 2

struct thread_info {
 struct task_struct *task;
 struct exec_domain *exec_domain;
 __u32 flags;
 __u32 status;
 __u32 cpu;
 int saved_preempt_count;
 mm_segment_t addr_limit;
 struct restart_block restart_block;
 void *sysenter_return;

 unsigned long previous_esp;


 __u8 supervisor_stack[0];

 unsigned int sig_on_uaccess_error:1;
 unsigned int uaccess_err:1;
};
# 170 "/usr/src/linux-2.6/arch/x86/include/asm/thread_info.h"
register unsigned long current_stack_pointer asm("esp") __attribute__((__us=
ed__));


static inline __attribute__((no_instrument_function)) struct thread_info *c=
urrent_thread_info(void)
{
 return (struct thread_info *)
  (current_stack_pointer & ~((((1UL) << 12) << 1) - 1));
}
# 243 "/usr/src/linux-2.6/arch/x86/include/asm/thread_info.h"
static inline __attribute__((no_instrument_function)) void set_restore_sigm=
ask(void)
{
 struct thread_info *ti =3D current_thread_info();
 ti->status |=3D 0x0008;
 ({ int __ret_warn_on =3D !!(!(__builtin_constant_p((2)) ? constant_test_bi=
t((2), ((unsigned long *)&ti->flags)) : variable_test_bit((2), ((unsigned l=
ong *)&ti->flags)))); if (__builtin_expect(!!(__ret_warn_on), 0)) warn_slow=
path_null("/usr/src/linux-2.6/arch/x86/include/asm/thread_info.h", 247); __=
builtin_expect(!!(__ret_warn_on), 0); });
}
static inline __attribute__((no_instrument_function)) void clear_restore_si=
gmask(void)
{
 current_thread_info()->status &=3D ~0x0008;
}
static inline __attribute__((no_instrument_function)) bool test_restore_sig=
mask(void)
{
 return current_thread_info()->status & 0x0008;
}
static inline __attribute__((no_instrument_function)) bool test_and_clear_r=
estore_sigmask(void)
{
 struct thread_info *ti =3D current_thread_info();
 if (!(ti->status & 0x0008))
  return false;
 ti->status &=3D ~0x0008;
 return true;
}

static inline __attribute__((no_instrument_function)) bool is_ia32_task(voi=
d)
{

 return true;





 return false;
}



extern void arch_task_cache_init(void);
extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct=
 *src);
extern void arch_release_task_struct(struct task_struct *tsk);
# 55 "/usr/src/linux-2.6/include/linux/thread_info.h" 2
# 71 "/usr/src/linux-2.6/include/linux/thread_info.h"
static inline __attribute__((no_instrument_function)) void set_ti_thread_fl=
ag(struct thread_info *ti, int flag)
{
 set_bit(flag, (unsigned long *)&ti->flags);
}

static inline __attribute__((no_instrument_function)) void clear_ti_thread_=
flag(struct thread_info *ti, int flag)
{
 clear_bit(flag, (unsigned long *)&ti->flags);
}

static inline __attribute__((no_instrument_function)) int test_and_set_ti_t=
hread_flag(struct thread_info *ti, int flag)
{
 return test_and_set_bit(flag, (unsigned long *)&ti->flags);
}

static inline __attribute__((no_instrument_function)) int test_and_clear_ti=
_thread_flag(struct thread_info *ti, int flag)
{
 return test_and_clear_bit(flag, (unsigned long *)&ti->flags);
}

static inline __attribute__((no_instrument_function)) int test_ti_thread_fl=
ag(struct thread_info *ti, int flag)
{
 return (__builtin_constant_p((flag)) ? constant_test_bit((flag), ((unsigne=
d long *)&ti->flags)) : variable_test_bit((flag), ((unsigned long *)&ti->fl=
ags)));
}
# 107 "/usr/src/linux-2.6/include/linux/thread_info.h"
static inline __attribute__((no_instrument_function)) void set_need_resched=
(void)
{
# 119 "/usr/src/linux-2.6/include/linux/thread_info.h"
}
# 7 "/usr/src/linux-2.6/arch/x86/include/asm/preempt.h" 2

extern __attribute__((section(".data" ""))) __typeof__(int) __preempt_count;





static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) int preempt_count(void)
{
 return ({ typeof((__preempt_count)) pfo_ret__; switch (sizeof((__preempt_c=
ount))) { case 1: asm("mov" "b """ "%P" "1"",%0" : "=3Dq" (pfo_ret__) : "m"=
(__preempt_count)); break; case 2: asm("mov" "w """ "%P" "1"",%0" : "=3Dr" =
(pfo_ret__) : "m"(__preempt_count)); break; case 4: asm("mov" "l """ "%P" "=
1"",%0" : "=3Dr" (pfo_ret__) : "m"(__preempt_count)); break; case 8: asm("m=
ov" "q """ "%P" "1"",%0" : "=3Dr" (pfo_ret__) : "m"(__preempt_count)); brea=
k; default: __bad_percpu_size(); } pfo_ret__; }) & ~0x80000000;
}

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void preempt_count_set(int pc)
{
 do { typedef typeof((__preempt_count)) pto_T__; if (0) { pto_T__ pto_tmp__=
; pto_tmp__ =3D (pc); (void)pto_tmp__; } switch (sizeof((__preempt_count)))=
 { case 1: asm("mov" "b %1,""" "%P" "0" : "+m" ((__preempt_count)) : "qi" (=
(pto_T__)(pc))); break; case 2: asm("mov" "w %1,""" "%P" "0" : "+m" ((__pre=
empt_count)) : "ri" ((pto_T__)(pc))); break; case 4: asm("mov" "l %1,""" "%=
P" "0" : "+m" ((__preempt_count)) : "ri" ((pto_T__)(pc))); break; case 8: a=
sm("mov" "q %1,""" "%P" "0" : "+m" ((__preempt_count)) : "re" ((pto_T__)(pc=
))); break; default: __bad_percpu_size(); } } while (0);
}
# 48 "/usr/src/linux-2.6/arch/x86/include/asm/preempt.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void set_preempt_need_resched(void)
{
 do { typedef typeof((__preempt_count)) pto_T__; if (0) { pto_T__ pto_tmp__=
; pto_tmp__ =3D (~0x80000000); (void)pto_tmp__; } switch (sizeof((__preempt=
_count))) { case 1: asm("and" "b %1,""" "%P" "0" : "+m" ((__preempt_count))=
 : "qi" ((pto_T__)(~0x80000000))); break; case 2: asm("and" "w %1,""" "%P" =
"0" : "+m" ((__preempt_count)) : "ri" ((pto_T__)(~0x80000000))); break; cas=
e 4: asm("and" "l %1,""" "%P" "0" : "+m" ((__preempt_count)) : "ri" ((pto_T=
__)(~0x80000000))); break; case 8: asm("and" "q %1,""" "%P" "0" : "+m" ((__=
preempt_count)) : "re" ((pto_T__)(~0x80000000))); break; default: __bad_per=
cpu_size(); } } while (0);
}

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void clear_preempt_need_resched(void)
{
 do { typedef typeof((__preempt_count)) pto_T__; if (0) { pto_T__ pto_tmp__=
; pto_tmp__ =3D (0x80000000); (void)pto_tmp__; } switch (sizeof((__preempt_=
count))) { case 1: asm("or" "b %1,""" "%P" "0" : "+m" ((__preempt_count)) :=
 "qi" ((pto_T__)(0x80000000))); break; case 2: asm("or" "w %1,""" "%P" "0" =
: "+m" ((__preempt_count)) : "ri" ((pto_T__)(0x80000000))); break; case 4: =
asm("or" "l %1,""" "%P" "0" : "+m" ((__preempt_count)) : "ri" ((pto_T__)(0x=
80000000))); break; case 8: asm("or" "q %1,""" "%P" "0" : "+m" ((__preempt_=
count)) : "re" ((pto_T__)(0x80000000))); break; default: __bad_percpu_size(=
); } } while (0);
}

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) bool test_preempt_need_resched(void)
{
 return !(({ typeof((__preempt_count)) pfo_ret__; switch (sizeof((__preempt=
_count))) { case 1: asm("mov" "b """ "%P" "1"",%0" : "=3Dq" (pfo_ret__) : "=
m"(__preempt_count)); break; case 2: asm("mov" "w """ "%P" "1"",%0" : "=3Dr=
" (pfo_ret__) : "m"(__preempt_count)); break; case 4: asm("mov" "l """ "%P"=
 "1"",%0" : "=3Dr" (pfo_ret__) : "m"(__preempt_count)); break; case 8: asm(=
"mov" "q """ "%P" "1"",%0" : "=3Dr" (pfo_ret__) : "m"(__preempt_count)); br=
eak; default: __bad_percpu_size(); } pfo_ret__; }) & 0x80000000);
}





static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void __preempt_count_add(int val)
{
 do { typedef typeof((__preempt_count)) pao_T__; const int pao_ID__ =3D (__=
builtin_constant_p(val) && ((val) =3D=3D 1 || (val) =3D=3D -1)) ? (val) : 0=
; if (0) { pao_T__ pao_tmp__; pao_tmp__ =3D (val); (void)pao_tmp__; } switc=
h (sizeof((__preempt_count))) { case 1: if (pao_ID__ =3D=3D 1) asm("incb ""=
" "%P" "0" : "+m" ((__preempt_count))); else if (pao_ID__ =3D=3D -1) asm("d=
ecb """ "%P" "0" : "+m" ((__preempt_count))); else asm("addb %1, """ "%P" "=
0" : "+m" ((__preempt_count)) : "qi" ((pao_T__)(val))); break; case 2: if (=
pao_ID__ =3D=3D 1) asm("incw """ "%P" "0" : "+m" ((__preempt_count))); else=
 if (pao_ID__ =3D=3D -1) asm("decw """ "%P" "0" : "+m" ((__preempt_count)))=
; else asm("addw %1, """ "%P" "0" : "+m" ((__preempt_count)) : "ri" ((pao_T=
__)(val))); break; case 4: if (pao_ID__ =3D=3D 1) asm("incl """ "%P" "0" : =
"+m" ((__preempt_count))); else if (pao_ID__ =3D=3D -1) asm("decl """ "%P" =
"0" : "+m" ((__preempt_count))); else asm("addl %1, """ "%P" "0" : "+m" ((_=
_preempt_count)) : "ri" ((pao_T__)(val))); break; case 8: if (pao_ID__ =3D=
=3D 1) asm("incq """ "%P" "0" : "+m" ((__preempt_count))); else if (pao_ID_=
_ =3D=3D -1) asm("decq """ "%P" "0" : "+m" ((__preempt_count))); else asm("=
addq %1, """ "%P" "0" : "+m" ((__preempt_count)) : "re" ((pao_T__)(val))); =
break; default: __bad_percpu_size(); } } while (0);
}

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void __preempt_count_sub(int val)
{
 do { typedef typeof((__preempt_count)) pao_T__; const int pao_ID__ =3D (__=
builtin_constant_p(-val) && ((-val) =3D=3D 1 || (-val) =3D=3D -1)) ? (-val)=
 : 0; if (0) { pao_T__ pao_tmp__; pao_tmp__ =3D (-val); (void)pao_tmp__; } =
switch (sizeof((__preempt_count))) { case 1: if (pao_ID__ =3D=3D 1) asm("in=
cb """ "%P" "0" : "+m" ((__preempt_count))); else if (pao_ID__ =3D=3D -1) a=
sm("decb """ "%P" "0" : "+m" ((__preempt_count))); else asm("addb %1, """ "=
%P" "0" : "+m" ((__preempt_count)) : "qi" ((pao_T__)(-val))); break; case 2=
: if (pao_ID__ =3D=3D 1) asm("incw """ "%P" "0" : "+m" ((__preempt_count)))=
; else if (pao_ID__ =3D=3D -1) asm("decw """ "%P" "0" : "+m" ((__preempt_co=
unt))); else asm("addw %1, """ "%P" "0" : "+m" ((__preempt_count)) : "ri" (=
(pao_T__)(-val))); break; case 4: if (pao_ID__ =3D=3D 1) asm("incl """ "%P"=
 "0" : "+m" ((__preempt_count))); else if (pao_ID__ =3D=3D -1) asm("decl ""=
" "%P" "0" : "+m" ((__preempt_count))); else asm("addl %1, """ "%P" "0" : "=
+m" ((__preempt_count)) : "ri" ((pao_T__)(-val))); break; case 8: if (pao_I=
D__ =3D=3D 1) asm("incq """ "%P" "0" : "+m" ((__preempt_count))); else if (=
pao_ID__ =3D=3D -1) asm("decq """ "%P" "0" : "+m" ((__preempt_count))); els=
e asm("addq %1, """ "%P" "0" : "+m" ((__preempt_count)) : "re" ((pao_T__)(-=
val))); break; default: __bad_percpu_size(); } } while (0);
}

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) bool __preempt_count_dec_and_test(void)
{
 do { asm volatile goto ("decl" " " "" "%P" "0" "; j" "e" " %l[cc_label]" :=
 : "m" (__preempt_count) : "memory" : cc_label); return 0; cc_label: return=
 1; } while (0);
}




static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) bool should_resched(void)
{
 return __builtin_expect(!!(!({ typeof((__preempt_count)) pfo_ret__; switch=
 (sizeof((__preempt_count))) { case 1: asm("mov" "b """ "%P" "1"",%0" : "=
=3Dq" (pfo_ret__) : "m"(__preempt_count)); break; case 2: asm("mov" "w """ =
"%P" "1"",%0" : "=3Dr" (pfo_ret__) : "m"(__preempt_count)); break; case 4: =
asm("mov" "l """ "%P" "1"",%0" : "=3Dr" (pfo_ret__) : "m"(__preempt_count))=
; break; case 8: asm("mov" "q """ "%P" "1"",%0" : "=3Dr" (pfo_ret__) : "m"(=
__preempt_count)); break; default: __bad_percpu_size(); } pfo_ret__; })), 0=
);
}
# 19 "/usr/src/linux-2.6/include/linux/preempt.h" 2
# 51 "/usr/src/linux-2.6/include/linux/spinlock.h" 2






# 1 "/usr/src/linux-2.6/include/linux/bottom_half.h" 1



extern void local_bh_disable(void);
extern void _local_bh_enable(void);
extern void local_bh_enable(void);
extern void local_bh_enable_ip(unsigned long ip);
# 58 "/usr/src/linux-2.6/include/linux/spinlock.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/barrier.h" 1
# 110 "/usr/src/linux-2.6/arch/x86/include/asm/barrier.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void rdtsc_barrier(void)
{
 asm volatile ("661:\n\t" ".byte " "0x8d,0x76,0x00" "\n" "\n662:\n" ".pushs=
ection .altinstructions,\"a\"\n" " .long 661b - .\n" " .long " "663""1""f -=
 .\n" " .word " "(3*32+17)" "\n" " .byte " "662b-661b" "\n" " .byte " "664"=
"1""f-""663""1""f" "\n" ".popsection\n" ".pushsection .discard,\"aw\",@prog=
bits\n" " .byte 0xff + (" "664""1""f-""663""1""f" ") - (" "662b-661b" ")\n"=
 ".popsection\n" ".pushsection .altinstr_replacement, \"ax\"\n" "663""1"":\=
n\t" "mfence" "\n" "664""1" ":\n\t" ".popsection" : : : "memory");
 asm volatile ("661:\n\t" ".byte " "0x8d,0x76,0x00" "\n" "\n662:\n" ".pushs=
ection .altinstructions,\"a\"\n" " .long 661b - .\n" " .long " "663""1""f -=
 .\n" " .word " "(3*32+18)" "\n" " .byte " "662b-661b" "\n" " .byte " "664"=
"1""f-""663""1""f" "\n" ".popsection\n" ".pushsection .discard,\"aw\",@prog=
bits\n" " .byte 0xff + (" "664""1""f-""663""1""f" ") - (" "662b-661b" ")\n"=
 ".popsection\n" ".pushsection .altinstr_replacement, \"ax\"\n" "663""1"":\=
n\t" "lfence" "\n" "664""1" ":\n\t" ".popsection" : : : "memory");
}
# 59 "/usr/src/linux-2.6/include/linux/spinlock.h" 2
# 81 "/usr/src/linux-2.6/include/linux/spinlock.h"
# 1 "/usr/src/linux-2.6/include/linux/spinlock_types.h" 1
# 15 "/usr/src/linux-2.6/include/linux/spinlock_types.h"
# 1 "/usr/src/linux-2.6/include/linux/spinlock_types_up.h" 1
# 25 "/usr/src/linux-2.6/include/linux/spinlock_types_up.h"
typedef struct { } arch_spinlock_t;





typedef struct {

} arch_rwlock_t;
# 16 "/usr/src/linux-2.6/include/linux/spinlock_types.h" 2


# 1 "/usr/src/linux-2.6/include/linux/lockdep.h" 1
# 12 "/usr/src/linux-2.6/include/linux/lockdep.h"
struct task_struct;
struct lockdep_map;


extern int prove_locking;
extern int lock_stat;
# 370 "/usr/src/linux-2.6/include/linux/lockdep.h"
static inline __attribute__((no_instrument_function)) void lockdep_off(void)
{
}

static inline __attribute__((no_instrument_function)) void lockdep_on(void)
{
}
# 411 "/usr/src/linux-2.6/include/linux/lockdep.h"
struct lock_class_key { };
# 465 "/usr/src/linux-2.6/include/linux/lockdep.h"
static inline __attribute__((no_instrument_function)) void print_irqtrace_e=
vents(struct task_struct *curr)
{
}
# 19 "/usr/src/linux-2.6/include/linux/spinlock_types.h" 2

typedef struct raw_spinlock {
 arch_spinlock_t raw_lock;
# 32 "/usr/src/linux-2.6/include/linux/spinlock_types.h"
} raw_spinlock_t;
# 64 "/usr/src/linux-2.6/include/linux/spinlock_types.h"
typedef struct spinlock {
 union {
  struct raw_spinlock rlock;
# 75 "/usr/src/linux-2.6/include/linux/spinlock_types.h"
 };
} spinlock_t;
# 86 "/usr/src/linux-2.6/include/linux/spinlock_types.h"
# 1 "/usr/src/linux-2.6/include/linux/rwlock_types.h" 1
# 11 "/usr/src/linux-2.6/include/linux/rwlock_types.h"
typedef struct {
 arch_rwlock_t raw_lock;
# 23 "/usr/src/linux-2.6/include/linux/rwlock_types.h"
} rwlock_t;
# 87 "/usr/src/linux-2.6/include/linux/spinlock_types.h" 2
# 82 "/usr/src/linux-2.6/include/linux/spinlock.h" 2







# 1 "/usr/src/linux-2.6/include/linux/spinlock_up.h" 1
# 90 "/usr/src/linux-2.6/include/linux/spinlock.h" 2
# 145 "/usr/src/linux-2.6/include/linux/spinlock.h"
static inline __attribute__((no_instrument_function)) void do_raw_spin_lock=
(raw_spinlock_t *lock)
{
 (void)0;
 do { __asm__ __volatile__("": : :"memory"); (void)(&lock->raw_lock); } whi=
le (0);
}

static inline __attribute__((no_instrument_function)) void
do_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags)
{
 (void)0;
 do { __asm__ __volatile__("": : :"memory"); (void)(&lock->raw_lock); } whi=
le (0);
}

static inline __attribute__((no_instrument_function)) int do_raw_spin_trylo=
ck(raw_spinlock_t *lock)
{
 return ({ __asm__ __volatile__("": : :"memory"); (void)(&(lock)->raw_lock)=
; 1; });
}

static inline __attribute__((no_instrument_function)) void do_raw_spin_unlo=
ck(raw_spinlock_t *lock)
{
 do { __asm__ __volatile__("": : :"memory"); (void)(&lock->raw_lock); } whi=
le (0);
 (void)0;
}
# 265 "/usr/src/linux-2.6/include/linux/spinlock.h"
# 1 "/usr/src/linux-2.6/include/linux/rwlock.h" 1
# 266 "/usr/src/linux-2.6/include/linux/spinlock.h" 2







# 1 "/usr/src/linux-2.6/include/linux/spinlock_api_up.h" 1
# 274 "/usr/src/linux-2.6/include/linux/spinlock.h" 2






static inline __attribute__((no_instrument_function)) raw_spinlock_t *spinl=
ock_check(spinlock_t *lock)
{
 return &lock->rlock;
}







static inline __attribute__((no_instrument_function)) void spin_lock(spinlo=
ck_t *lock)
{
 do { __asm__ __volatile__("": : :"memory"); (void)0; (void)(&lock->rlock);=
 } while (0);
}

static inline __attribute__((no_instrument_function)) void spin_lock_bh(spi=
nlock_t *lock)
{
 do { local_bh_disable(); do { __asm__ __volatile__("": : :"memory"); (void=
)0; (void)(&lock->rlock); } while (0); } while (0);
}

static inline __attribute__((no_instrument_function)) int spin_trylock(spin=
lock_t *lock)
{
 return (({ do { __asm__ __volatile__("": : :"memory"); (void)0; (void)(&lo=
ck->rlock); } while (0); 1; }));
}
# 316 "/usr/src/linux-2.6/include/linux/spinlock.h"
static inline __attribute__((no_instrument_function)) void spin_lock_irq(sp=
inlock_t *lock)
{
 do { do { arch_local_irq_disable(); do { } while (0); } while (0); do { __=
asm__ __volatile__("": : :"memory"); (void)0; (void)(&lock->rlock); } while=
 (0); } while (0);
}
# 331 "/usr/src/linux-2.6/include/linux/spinlock.h"
static inline __attribute__((no_instrument_function)) void spin_unlock(spin=
lock_t *lock)
{
 do { __asm__ __volatile__("": : :"memory"); (void)0; (void)(&lock->rlock);=
 } while (0);
}

static inline __attribute__((no_instrument_function)) void spin_unlock_bh(s=
pinlock_t *lock)
{
 do { __asm__ __volatile__("": : :"memory"); local_bh_enable(); (void)0; (v=
oid)(&lock->rlock); } while (0);
}

static inline __attribute__((no_instrument_function)) void spin_unlock_irq(=
spinlock_t *lock)
{
 do { do { do { } while (0); arch_local_irq_enable(); } while (0); do { __a=
sm__ __volatile__("": : :"memory"); (void)0; (void)(&lock->rlock); } while =
(0); } while (0);
}

static inline __attribute__((no_instrument_function)) void spin_unlock_irqr=
estore(spinlock_t *lock, unsigned long flags)
{
 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); do { do { if (({ ({ unsigned long __dummy; typeof(fl=
ags) __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); arch_irqs_disabled=
_flags(flags); })) { do { ({ unsigned long __dummy; typeof(flags) __dummy2;=
 (void)(&__dummy =3D=3D &__dummy2); 1; }); arch_local_irq_restore(flags); }=
 while (0); do { } while (0); } else { do { } while (0); do { ({ unsigned l=
ong __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; =
}); arch_local_irq_restore(flags); } while (0); } } while (0); do { __asm__=
 __volatile__("": : :"memory"); (void)0; (void)(&lock->rlock); } while (0);=
 } while (0); } while (0);
}

static inline __attribute__((no_instrument_function)) int spin_trylock_bh(s=
pinlock_t *lock)
{
 return (({ do { local_bh_disable(); do { __asm__ __volatile__("": : :"memo=
ry"); (void)0; (void)(&lock->rlock); } while (0); } while (0); 1; }));
}

static inline __attribute__((no_instrument_function)) int spin_trylock_irq(=
spinlock_t *lock)
{
 return ({ do { arch_local_irq_disable(); do { } while (0); } while (0); ((=
{ do { __asm__ __volatile__("": : :"memory"); (void)0; (void)(&lock->rlock)=
; } while (0); 1; })) ? 1 : ({ do { do { } while (0); arch_local_irq_enable=
(); } while (0); 0; }); });
}






static inline __attribute__((no_instrument_function)) void spin_unlock_wait=
(spinlock_t *lock)
{
 do { cpu_relax(); } while (((void)(&(&lock->rlock)->raw_lock), 0));
}

static inline __attribute__((no_instrument_function)) int spin_is_locked(sp=
inlock_t *lock)
{
 return ((void)(&(&lock->rlock)->raw_lock), 0);
}

static inline __attribute__((no_instrument_function)) int spin_is_contended=
(spinlock_t *lock)
{
 return (((void)(&(&lock->rlock)->raw_lock), 0));
}

static inline __attribute__((no_instrument_function)) int spin_can_lock(spi=
nlock_t *lock)
{
 return (!((void)(&(&lock->rlock)->raw_lock), 0));
}
# 401 "/usr/src/linux-2.6/include/linux/spinlock.h"
extern int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock);
# 2 "/usr/src/linux-2.6/kernel/task_work.c" 2
# 1 "/usr/src/linux-2.6/include/linux/task_work.h" 1




# 1 "/usr/src/linux-2.6/include/linux/sched.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/sched.h" 1
# 5 "/usr/src/linux-2.6/include/linux/sched.h" 2


struct sched_param {
 int sched_priority;
};

# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/param.h" 1
# 1 "/usr/src/linux-2.6/include/asm-generic/param.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/param.h" 1
# 5 "/usr/src/linux-2.6/include/asm-generic/param.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/param.h" 2
# 12 "/usr/src/linux-2.6/include/linux/sched.h" 2

# 1 "/usr/src/linux-2.6/include/linux/capability.h" 1
# 15 "/usr/src/linux-2.6/include/linux/capability.h"
# 1 "/usr/src/linux-2.6/include/uapi/linux/capability.h" 1
# 18 "/usr/src/linux-2.6/include/uapi/linux/capability.h"
struct task_struct;
# 40 "/usr/src/linux-2.6/include/uapi/linux/capability.h"
typedef struct __user_cap_header_struct {
 __u32 version;
 int pid;
} *cap_user_header_t;

typedef struct __user_cap_data_struct {
        __u32 effective;
        __u32 permitted;
        __u32 inheritable;
} *cap_user_data_t;
# 69 "/usr/src/linux-2.6/include/uapi/linux/capability.h"
struct vfs_cap_data {
 __le32 magic_etc;
 struct {
  __le32 permitted;
  __le32 inheritable;
 } data[2];
};
# 16 "/usr/src/linux-2.6/include/linux/capability.h" 2





extern int file_caps_enabled;

typedef struct kernel_cap_struct {
 __u32 cap[2];
} kernel_cap_t;


struct cpu_vfs_cap_data {
 __u32 magic_etc;
 kernel_cap_t permitted;
 kernel_cap_t inheritable;
};





struct file;
struct inode;
struct dentry;
struct user_namespace;

struct user_namespace *current_user_ns(void);

extern const kernel_cap_t __cap_empty_set;
extern const kernel_cap_t __cap_init_eff_set;
# 114 "/usr/src/linux-2.6/include/linux/capability.h"
static inline __attribute__((no_instrument_function)) kernel_cap_t cap_comb=
ine(const kernel_cap_t a,
           const kernel_cap_t b)
{
 kernel_cap_t dest;
 do { unsigned __capi; for (__capi =3D 0; __capi < 2; ++__capi) { dest.cap[=
__capi] =3D a.cap[__capi] | b.cap[__capi]; } } while (0);
 return dest;
}

static inline __attribute__((no_instrument_function)) kernel_cap_t cap_inte=
rsect(const kernel_cap_t a,
      const kernel_cap_t b)
{
 kernel_cap_t dest;
 do { unsigned __capi; for (__capi =3D 0; __capi < 2; ++__capi) { dest.cap[=
__capi] =3D a.cap[__capi] & b.cap[__capi]; } } while (0);
 return dest;
}

static inline __attribute__((no_instrument_function)) kernel_cap_t cap_drop=
(const kernel_cap_t a,
        const kernel_cap_t drop)
{
 kernel_cap_t dest;
 do { unsigned __capi; for (__capi =3D 0; __capi < 2; ++__capi) { dest.cap[=
__capi] =3D a.cap[__capi] &~ drop.cap[__capi]; } } while (0);
 return dest;
}

static inline __attribute__((no_instrument_function)) kernel_cap_t cap_inve=
rt(const kernel_cap_t c)
{
 kernel_cap_t dest;
 do { unsigned __capi; for (__capi =3D 0; __capi < 2; ++__capi) { dest.cap[=
__capi] =3D ~ c.cap[__capi]; } } while (0);
 return dest;
}

static inline __attribute__((no_instrument_function)) int cap_isclear(const=
 kernel_cap_t a)
{
 unsigned __capi;
 for (__capi =3D 0; __capi < 2; ++__capi) {
  if (a.cap[__capi] !=3D 0)
   return 0;
 }
 return 1;
}
# 162 "/usr/src/linux-2.6/include/linux/capability.h"
static inline __attribute__((no_instrument_function)) int cap_issubset(cons=
t kernel_cap_t a, const kernel_cap_t set)
{
 kernel_cap_t dest;
 dest =3D cap_drop(a, set);
 return cap_isclear(dest);
}



static inline __attribute__((no_instrument_function)) int cap_is_fs_cap(int=
 cap)
{
 const kernel_cap_t __cap_fs_set =3D ((kernel_cap_t){{ ((1 << ((0) & 31)) |=
 (1 << ((27) & 31)) | (1 << ((1) & 31)) | (1 << ((2) & 31)) | (1 << ((3) & =
31)) | (1 << ((4) & 31))) | (1 << ((9) & 31)), ((1 << ((32) & 31))) } });
 return !!((1 << ((cap) & 31)) & __cap_fs_set.cap[((cap) >> 5)]);
}

static inline __attribute__((no_instrument_function)) kernel_cap_t cap_drop=
_fs_set(const kernel_cap_t a)
{
 const kernel_cap_t __cap_fs_set =3D ((kernel_cap_t){{ ((1 << ((0) & 31)) |=
 (1 << ((27) & 31)) | (1 << ((1) & 31)) | (1 << ((2) & 31)) | (1 << ((3) & =
31)) | (1 << ((4) & 31))) | (1 << ((9) & 31)), ((1 << ((32) & 31))) } });
 return cap_drop(a, __cap_fs_set);
}

static inline __attribute__((no_instrument_function)) kernel_cap_t cap_rais=
e_fs_set(const kernel_cap_t a,
         const kernel_cap_t permitted)
{
 const kernel_cap_t __cap_fs_set =3D ((kernel_cap_t){{ ((1 << ((0) & 31)) |=
 (1 << ((27) & 31)) | (1 << ((1) & 31)) | (1 << ((2) & 31)) | (1 << ((3) & =
31)) | (1 << ((4) & 31))) | (1 << ((9) & 31)), ((1 << ((32) & 31))) } });
 return cap_combine(a,
      cap_intersect(permitted, __cap_fs_set));
}

static inline __attribute__((no_instrument_function)) kernel_cap_t cap_drop=
_nfsd_set(const kernel_cap_t a)
{
 const kernel_cap_t __cap_fs_set =3D ((kernel_cap_t){{ ((1 << ((0) & 31)) |=
 (1 << ((27) & 31)) | (1 << ((1) & 31)) | (1 << ((2) & 31)) | (1 << ((3) & =
31)) | (1 << ((4) & 31))) | (1 << ((24) & 31)), ((1 << ((32) & 31))) } });
 return cap_drop(a, __cap_fs_set);
}

static inline __attribute__((no_instrument_function)) kernel_cap_t cap_rais=
e_nfsd_set(const kernel_cap_t a,
           const kernel_cap_t permitted)
{
 const kernel_cap_t __cap_nfsd_set =3D ((kernel_cap_t){{ ((1 << ((0) & 31))=
 | (1 << ((27) & 31)) | (1 << ((1) & 31)) | (1 << ((2) & 31)) | (1 << ((3) =
& 31)) | (1 << ((4) & 31))) | (1 << ((24) & 31)), ((1 << ((32) & 31))) } });
 return cap_combine(a,
      cap_intersect(permitted, __cap_nfsd_set));
}

extern bool has_capability(struct task_struct *t, int cap);
extern bool has_ns_capability(struct task_struct *t,
         struct user_namespace *ns, int cap);
extern bool has_capability_noaudit(struct task_struct *t, int cap);
extern bool has_ns_capability_noaudit(struct task_struct *t,
          struct user_namespace *ns, int cap);
extern bool capable(int cap);
extern bool ns_capable(struct user_namespace *ns, int cap);
extern bool inode_capable(const struct inode *inode, int cap);
extern bool file_ns_capable(const struct file *file, struct user_namespace =
*ns, int cap);


extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_v=
fs_cap_data *cpu_caps);
# 14 "/usr/src/linux-2.6/include/linux/sched.h" 2



# 1 "/usr/src/linux-2.6/include/linux/timex.h" 1
# 56 "/usr/src/linux-2.6/include/linux/timex.h"
# 1 "/usr/src/linux-2.6/include/uapi/linux/timex.h" 1
# 56 "/usr/src/linux-2.6/include/uapi/linux/timex.h"
# 1 "/usr/src/linux-2.6/include/linux/time.h" 1




# 1 "/usr/src/linux-2.6/include/linux/seqlock.h" 1
# 45 "/usr/src/linux-2.6/include/linux/seqlock.h"
typedef struct seqcount {
 unsigned sequence;
} seqcount_t;
# 65 "/usr/src/linux-2.6/include/linux/seqlock.h"
static inline __attribute__((no_instrument_function)) unsigned __read_seqco=
unt_begin(const seqcount_t *s)
{
 unsigned ret;

repeat:
 ret =3D (*(volatile typeof(s->sequence) *)&(s->sequence));
 if (__builtin_expect(!!(ret & 1), 0)) {
  cpu_relax();
  goto repeat;
 }
 return ret;
}
# 87 "/usr/src/linux-2.6/include/linux/seqlock.h"
static inline __attribute__((no_instrument_function)) unsigned read_seqcoun=
t_begin(const seqcount_t *s)
{
 unsigned ret =3D __read_seqcount_begin(s);
 __asm__ __volatile__("": : :"memory");
 return ret;
}
# 108 "/usr/src/linux-2.6/include/linux/seqlock.h"
static inline __attribute__((no_instrument_function)) unsigned raw_seqcount=
_begin(const seqcount_t *s)
{
 unsigned ret =3D (*(volatile typeof(s->sequence) *)&(s->sequence));
 __asm__ __volatile__("": : :"memory");
 return ret & ~1;
}
# 129 "/usr/src/linux-2.6/include/linux/seqlock.h"
static inline __attribute__((no_instrument_function)) int __read_seqcount_r=
etry(const seqcount_t *s, unsigned start)
{
 return __builtin_expect(!!(s->sequence !=3D start), 0);
}
# 144 "/usr/src/linux-2.6/include/linux/seqlock.h"
static inline __attribute__((no_instrument_function)) int read_seqcount_ret=
ry(const seqcount_t *s, unsigned start)
{
 __asm__ __volatile__("": : :"memory");
 return __read_seqcount_retry(s, start);
}






static inline __attribute__((no_instrument_function)) void write_seqcount_b=
egin(seqcount_t *s)
{
 s->sequence++;
 __asm__ __volatile__("": : :"memory");
}

static inline __attribute__((no_instrument_function)) void write_seqcount_e=
nd(seqcount_t *s)
{
 __asm__ __volatile__("": : :"memory");
 s->sequence++;
}
# 174 "/usr/src/linux-2.6/include/linux/seqlock.h"
static inline __attribute__((no_instrument_function)) void write_seqcount_b=
arrier(seqcount_t *s)
{
 __asm__ __volatile__("": : :"memory");
 s->sequence+=3D2;
}

typedef struct {
 struct seqcount seqcount;
 spinlock_t lock;
} seqlock_t;
# 207 "/usr/src/linux-2.6/include/linux/seqlock.h"
static inline __attribute__((no_instrument_function)) unsigned read_seqbegi=
n(const seqlock_t *sl)
{
 return read_seqcount_begin(&sl->seqcount);
}

static inline __attribute__((no_instrument_function)) unsigned read_seqretr=
y(const seqlock_t *sl, unsigned start)
{
 return read_seqcount_retry(&sl->seqcount, start);
}






static inline __attribute__((no_instrument_function)) void write_seqlock(se=
qlock_t *sl)
{
 spin_lock(&sl->lock);
 write_seqcount_begin(&sl->seqcount);
}

static inline __attribute__((no_instrument_function)) void write_sequnlock(=
seqlock_t *sl)
{
 write_seqcount_end(&sl->seqcount);
 spin_unlock(&sl->lock);
}

static inline __attribute__((no_instrument_function)) void write_seqlock_bh=
(seqlock_t *sl)
{
 spin_lock_bh(&sl->lock);
 write_seqcount_begin(&sl->seqcount);
}

static inline __attribute__((no_instrument_function)) void write_sequnlock_=
bh(seqlock_t *sl)
{
 write_seqcount_end(&sl->seqcount);
 spin_unlock_bh(&sl->lock);
}

static inline __attribute__((no_instrument_function)) void write_seqlock_ir=
q(seqlock_t *sl)
{
 spin_lock_irq(&sl->lock);
 write_seqcount_begin(&sl->seqcount);
}

static inline __attribute__((no_instrument_function)) void write_sequnlock_=
irq(seqlock_t *sl)
{
 write_seqcount_end(&sl->seqcount);
 spin_unlock_irq(&sl->lock);
}

static inline __attribute__((no_instrument_function)) unsigned long __write=
_seqlock_irqsave(seqlock_t *sl)
{
 unsigned long flags;

 do { do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dumm=
y =3D=3D &__dummy2); 1; }); do { do { do { ({ unsigned long __dummy; typeof=
(flags) __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); flags =3D arch_=
local_irq_save(); } while (0); do { } while (0); } while (0); do { __asm__ =
__volatile__("": : :"memory"); (void)0; (void)(spinlock_check(&sl->lock)); =
} while (0); } while (0); } while (0); } while (0);
 write_seqcount_begin(&sl->seqcount);
 return flags;
}




static inline __attribute__((no_instrument_function)) void
write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
{
 write_seqcount_end(&sl->seqcount);
 spin_unlock_irqrestore(&sl->lock, flags);
}






static inline __attribute__((no_instrument_function)) void read_seqlock_exc=
l(seqlock_t *sl)
{
 spin_lock(&sl->lock);
}

static inline __attribute__((no_instrument_function)) void read_sequnlock_e=
xcl(seqlock_t *sl)
{
 spin_unlock(&sl->lock);
}

static inline __attribute__((no_instrument_function)) void read_seqlock_exc=
l_bh(seqlock_t *sl)
{
 spin_lock_bh(&sl->lock);
}

static inline __attribute__((no_instrument_function)) void read_sequnlock_e=
xcl_bh(seqlock_t *sl)
{
 spin_unlock_bh(&sl->lock);
}

static inline __attribute__((no_instrument_function)) void read_seqlock_exc=
l_irq(seqlock_t *sl)
{
 spin_lock_irq(&sl->lock);
}

static inline __attribute__((no_instrument_function)) void read_sequnlock_e=
xcl_irq(seqlock_t *sl)
{
 spin_unlock_irq(&sl->lock);
}

static inline __attribute__((no_instrument_function)) unsigned long __read_=
seqlock_excl_irqsave(seqlock_t *sl)
{
 unsigned long flags;

 do { do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dumm=
y =3D=3D &__dummy2); 1; }); do { do { do { ({ unsigned long __dummy; typeof=
(flags) __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); flags =3D arch_=
local_irq_save(); } while (0); do { } while (0); } while (0); do { __asm__ =
__volatile__("": : :"memory"); (void)0; (void)(spinlock_check(&sl->lock)); =
} while (0); } while (0); } while (0); } while (0);
 return flags;
}




static inline __attribute__((no_instrument_function)) void
read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
{
 spin_unlock_irqrestore(&sl->lock, flags);
}
# 6 "/usr/src/linux-2.6/include/linux/time.h" 2

# 1 "/usr/src/linux-2.6/include/uapi/linux/time.h" 1
# 9 "/usr/src/linux-2.6/include/uapi/linux/time.h"
struct timespec {
 __kernel_time_t tv_sec;
 long tv_nsec;
};


struct timeval {
 __kernel_time_t tv_sec;
 __kernel_suseconds_t tv_usec;
};

struct timezone {
 int tz_minuteswest;
 int tz_dsttime;
};
# 34 "/usr/src/linux-2.6/include/uapi/linux/time.h"
struct itimerspec {
 struct timespec it_interval;
 struct timespec it_value;
};

struct itimerval {
 struct timeval it_interval;
 struct timeval it_value;
};
# 8 "/usr/src/linux-2.6/include/linux/time.h" 2

extern struct timezone sys_tz;
# 22 "/usr/src/linux-2.6/include/linux/time.h"
static inline __attribute__((no_instrument_function)) int timespec_equal(co=
nst struct timespec *a,
                                 const struct timespec *b)
{
 return (a->tv_sec =3D=3D b->tv_sec) && (a->tv_nsec =3D=3D b->tv_nsec);
}






static inline __attribute__((no_instrument_function)) int timespec_compare(=
const struct timespec *lhs, const struct timespec *rhs)
{
 if (lhs->tv_sec < rhs->tv_sec)
  return -1;
 if (lhs->tv_sec > rhs->tv_sec)
  return 1;
 return lhs->tv_nsec - rhs->tv_nsec;
}

static inline __attribute__((no_instrument_function)) int timeval_compare(c=
onst struct timeval *lhs, const struct timeval *rhs)
{
 if (lhs->tv_sec < rhs->tv_sec)
  return -1;
 if (lhs->tv_sec > rhs->tv_sec)
  return 1;
 return lhs->tv_usec - rhs->tv_usec;
}

extern unsigned long mktime(const unsigned int year, const unsigned int mon,
       const unsigned int day, const unsigned int hour,
       const unsigned int min, const unsigned int sec);

extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 ns=
ec);






extern struct timespec timespec_add_safe(const struct timespec lhs,
      const struct timespec rhs);


static inline __attribute__((no_instrument_function)) struct timespec times=
pec_add(struct timespec lhs,
      struct timespec rhs)
{
 struct timespec ts_delta;
 set_normalized_timespec(&ts_delta, lhs.tv_sec + rhs.tv_sec,
    lhs.tv_nsec + rhs.tv_nsec);
 return ts_delta;
}




static inline __attribute__((no_instrument_function)) struct timespec times=
pec_sub(struct timespec lhs,
      struct timespec rhs)
{
 struct timespec ts_delta;
 set_normalized_timespec(&ts_delta, lhs.tv_sec - rhs.tv_sec,
    lhs.tv_nsec - rhs.tv_nsec);
 return ts_delta;
}
# 97 "/usr/src/linux-2.6/include/linux/time.h"
static inline __attribute__((no_instrument_function)) bool timespec_valid(c=
onst struct timespec *ts)
{

 if (ts->tv_sec < 0)
  return false;

 if ((unsigned long)ts->tv_nsec >=3D 1000000000L)
  return false;
 return true;
}

static inline __attribute__((no_instrument_function)) bool timespec_valid_s=
trict(const struct timespec *ts)
{
 if (!timespec_valid(ts))
  return false;

 if ((unsigned long long)ts->tv_sec >=3D ((long)(~0UL>>1)))
  return false;
 return true;
}

extern bool persistent_clock_exist;

static inline __attribute__((no_instrument_function)) bool has_persistent_c=
lock(void)
{
 return persistent_clock_exist;
}

extern void read_persistent_clock(struct timespec *ts);
extern void read_boot_clock(struct timespec *ts);
extern int persistent_clock_is_local;
extern int update_persistent_clock(struct timespec now);
void timekeeping_init(void);
extern int timekeeping_suspended;

unsigned long get_seconds(void);
struct timespec current_kernel_time(void);
struct timespec __current_kernel_time(void);
struct timespec get_monotonic_coarse(void);
void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
    struct timespec *wtom, struct timespec *sleep);
void timekeeping_inject_sleeptime(struct timespec *delta);
# 156 "/usr/src/linux-2.6/include/linux/time.h"
extern void do_gettimeofday(struct timeval *tv);
extern int do_settimeofday(const struct timespec *tv);
extern int do_sys_settimeofday(const struct timespec *tv,
          const struct timezone *tz);

extern long do_utimes(int dfd, const char *filename, struct timespec *times=
, int flags);
struct itimerval;
extern int do_setitimer(int which, struct itimerval *value,
   struct itimerval *ovalue);
extern unsigned int alarm_setitimer(unsigned int seconds);
extern int do_getitimer(int which, struct itimerval *value);
extern int __getnstimeofday(struct timespec *tv);
extern void getnstimeofday(struct timespec *tv);
extern void getrawmonotonic(struct timespec *ts);
extern void getnstime_raw_and_real(struct timespec *ts_raw,
  struct timespec *ts_real);
extern void getboottime(struct timespec *ts);
extern void monotonic_to_bootbased(struct timespec *ts);
extern void get_monotonic_boottime(struct timespec *ts);

extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
extern int timekeeping_valid_for_hres(void);
extern u64 timekeeping_max_deferment(void);
extern int timekeeping_inject_offset(struct timespec *ts);
extern s32 timekeeping_get_tai_offset(void);
extern void timekeeping_set_tai_offset(s32 tai_offset);
extern void timekeeping_clocktai(struct timespec *ts);

struct tms;
extern void do_sys_times(struct tms *);





struct tm {




 int tm_sec;

 int tm_min;

 int tm_hour;

 int tm_mday;

 int tm_mon;

 long tm_year;

 int tm_wday;

 int tm_yday;
};

void time_to_tm(time_t totalsecs, int offset, struct tm *result);
# 222 "/usr/src/linux-2.6/include/linux/time.h"
static inline __attribute__((no_instrument_function)) s64 timespec_to_ns(co=
nst struct timespec *ts)
{
 return ((s64) ts->tv_sec * 1000000000L) + ts->tv_nsec;
}
# 234 "/usr/src/linux-2.6/include/linux/time.h"
static inline __attribute__((no_instrument_function)) s64 timeval_to_ns(con=
st struct timeval *tv)
{
 return ((s64) tv->tv_sec * 1000000000L) +
  tv->tv_usec * 1000L;
}







extern struct timespec ns_to_timespec(const s64 nsec);







extern struct timeval ns_to_timeval(const s64 nsec);
# 264 "/usr/src/linux-2.6/include/linux/time.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void timespec_add_ns(struct timespec *a, u64 ns)
{
 a->tv_sec +=3D __iter_div_u64_rem(a->tv_nsec + ns, 1000000000L, &ns);
 a->tv_nsec =3D ns;
}
# 57 "/usr/src/linux-2.6/include/uapi/linux/timex.h" 2







struct timex {
 unsigned int modes;
 long offset;
 long freq;
 long maxerror;
 long esterror;
 int status;
 long constant;
 long precision;
 long tolerance;


 struct timeval time;
 long tick;

 long ppsfreq;
 long jitter;
 int shift;
 long stabil;
 long jitcnt;
 long calcnt;
 long errcnt;
 long stbcnt;

 int tai;

 int :32; int :32; int :32; int :32;
 int :32; int :32; int :32; int :32;
 int :32; int :32; int :32;
};
# 57 "/usr/src/linux-2.6/include/linux/timex.h" 2






# 1 "/usr/src/linux-2.6/include/uapi/linux/param.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/param.h" 1
# 5 "/usr/src/linux-2.6/include/uapi/linux/param.h" 2
# 64 "/usr/src/linux-2.6/include/linux/timex.h" 2

# 1 "/usr/src/linux-2.6/arch/x86/include/asm/timex.h" 1




# 1 "/usr/src/linux-2.6/arch/x86/include/asm/tsc.h" 1
# 15 "/usr/src/linux-2.6/arch/x86/include/asm/tsc.h"
typedef unsigned long long cycles_t;

extern unsigned int cpu_khz;
extern unsigned int tsc_khz;

extern void disable_TSC(void);

static inline __attribute__((no_instrument_function)) cycles_t get_cycles(v=
oid)
{
 unsigned long long ret =3D 0;





 ((ret) =3D __native_read_tsc());

 return ret;
}

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) cycles_t vget_cycles(void)
{
# 45 "/usr/src/linux-2.6/arch/x86/include/asm/tsc.h"
 return (cycles_t)__native_read_tsc();
}

extern void tsc_init(void);
extern void mark_tsc_unstable(char *reason);
extern int unsynchronized_tsc(void);
extern int check_tsc_unstable(void);
extern int check_tsc_disabled(void);
extern unsigned long native_calibrate_tsc(void);

extern int tsc_clocksource_reliable;





extern void check_tsc_sync_source(int cpu);
extern void check_tsc_sync_target(void);

extern int notsc_setup(char *);
extern void tsc_save_sched_clock_state(void);
extern void tsc_restore_sched_clock_state(void);
# 6 "/usr/src/linux-2.6/arch/x86/include/asm/timex.h" 2
# 66 "/usr/src/linux-2.6/include/linux/timex.h" 2
# 125 "/usr/src/linux-2.6/include/linux/timex.h"
extern unsigned long tick_usec;
extern unsigned long tick_nsec;
# 140 "/usr/src/linux-2.6/include/linux/timex.h"
extern int do_adjtimex(struct timex *);
extern void hardpps(const struct timespec *, const struct timespec *);

int read_current_timer(unsigned long *timer_val);
void ntp_notify_cmos_timer(void);
# 18 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/jiffies.h" 1
# 9 "/usr/src/linux-2.6/include/linux/jiffies.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/param.h" 1
# 10 "/usr/src/linux-2.6/include/linux/jiffies.h" 2
# 57 "/usr/src/linux-2.6/include/linux/jiffies.h"
extern int register_refined_jiffies(long clock_tick_rate);
# 76 "/usr/src/linux-2.6/include/linux/jiffies.h"
extern u64 __attribute__((section(".data"))) jiffies_64;
extern unsigned long volatile __attribute__((section(".data"))) jiffies;


u64 get_jiffies_64(void);
# 182 "/usr/src/linux-2.6/include/linux/jiffies.h"
extern unsigned long preset_lpj;
# 295 "/usr/src/linux-2.6/include/linux/jiffies.h"
extern unsigned int jiffies_to_msecs(const unsigned long j);
extern unsigned int jiffies_to_usecs(const unsigned long j);
extern unsigned long msecs_to_jiffies(const unsigned int m);
extern unsigned long usecs_to_jiffies(const unsigned int u);
extern unsigned long timespec_to_jiffies(const struct timespec *value);
extern void jiffies_to_timespec(const unsigned long jiffies,
    struct timespec *value);
extern unsigned long timeval_to_jiffies(const struct timeval *value);
extern void jiffies_to_timeval(const unsigned long jiffies,
          struct timeval *value);

extern clock_t jiffies_to_clock_t(unsigned long x);
static inline __attribute__((no_instrument_function)) clock_t jiffies_delta=
_to_clock_t(long delta)
{
 return jiffies_to_clock_t(({ typeof(0L) _max1 =3D (0L); typeof(delta) _max=
2 =3D (delta); (void) (&_max1 =3D=3D &_max2); _max1 > _max2 ? _max1 : _max2=
; }));
}

extern unsigned long clock_t_to_jiffies(unsigned long x);
extern u64 jiffies_64_to_clock_t(u64 x);
extern u64 nsec_to_clock_t(u64 x);
extern u64 nsecs_to_jiffies64(u64 n);
extern unsigned long nsecs_to_jiffies(u64 n);
# 19 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/rbtree.h" 1
# 35 "/usr/src/linux-2.6/include/linux/rbtree.h"
struct rb_node {
 unsigned long __rb_parent_color;
 struct rb_node *rb_right;
 struct rb_node *rb_left;
} __attribute__((aligned(sizeof(long))));


struct rb_root {
 struct rb_node *rb_node;
};
# 61 "/usr/src/linux-2.6/include/linux/rbtree.h"
extern void rb_insert_color(struct rb_node *, struct rb_root *);
extern void rb_erase(struct rb_node *, struct rb_root *);



extern struct rb_node *rb_next(const struct rb_node *);
extern struct rb_node *rb_prev(const struct rb_node *);
extern struct rb_node *rb_first(const struct rb_root *);
extern struct rb_node *rb_last(const struct rb_root *);


extern struct rb_node *rb_first_postorder(const struct rb_root *);
extern struct rb_node *rb_next_postorder(const struct rb_node *);


extern void rb_replace_node(struct rb_node *victim, struct rb_node *new,
       struct rb_root *root);

static inline __attribute__((no_instrument_function)) void rb_link_node(str=
uct rb_node * node, struct rb_node * parent,
    struct rb_node ** rb_link)
{
 node->__rb_parent_color =3D (unsigned long)parent;
 node->rb_left =3D node->rb_right =3D ((void *)0);

 *rb_link =3D node;
}
# 20 "/usr/src/linux-2.6/include/linux/sched.h" 2



# 1 "/usr/src/linux-2.6/include/linux/nodemask.h" 1
# 96 "/usr/src/linux-2.6/include/linux/nodemask.h"
# 1 "/usr/src/linux-2.6/include/linux/numa.h" 1
# 97 "/usr/src/linux-2.6/include/linux/nodemask.h" 2

typedef struct { unsigned long bits[((((1 << 0)) + (8 * sizeof(long)) - 1) =
/ (8 * sizeof(long)))]; } nodemask_t;
extern nodemask_t _unused_nodemask_arg_;
# 111 "/usr/src/linux-2.6/include/linux/nodemask.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void __node_set(int node, volatile nodemask_t *dstp)
{
 set_bit(node, dstp->bits);
}


static inline __attribute__((no_instrument_function)) void __node_clear(int=
 node, volatile nodemask_t *dstp)
{
 clear_bit(node, dstp->bits);
}


static inline __attribute__((no_instrument_function)) void __nodes_setall(n=
odemask_t *dstp, int nbits)
{
 bitmap_fill(dstp->bits, nbits);
}


static inline __attribute__((no_instrument_function)) void __nodes_clear(no=
demask_t *dstp, int nbits)
{
 bitmap_zero(dstp->bits, nbits);
}






static inline __attribute__((no_instrument_function)) int __node_test_and_s=
et(int node, nodemask_t *addr)
{
 return test_and_set_bit(node, addr->bits);
}



static inline __attribute__((no_instrument_function)) void __nodes_and(node=
mask_t *dstp, const nodemask_t *src1p,
     const nodemask_t *src2p, int nbits)
{
 bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
}



static inline __attribute__((no_instrument_function)) void __nodes_or(nodem=
ask_t *dstp, const nodemask_t *src1p,
     const nodemask_t *src2p, int nbits)
{
 bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
}



static inline __attribute__((no_instrument_function)) void __nodes_xor(node=
mask_t *dstp, const nodemask_t *src1p,
     const nodemask_t *src2p, int nbits)
{
 bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
}



static inline __attribute__((no_instrument_function)) void __nodes_andnot(n=
odemask_t *dstp, const nodemask_t *src1p,
     const nodemask_t *src2p, int nbits)
{
 bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
}



static inline __attribute__((no_instrument_function)) void __nodes_compleme=
nt(nodemask_t *dstp,
     const nodemask_t *srcp, int nbits)
{
 bitmap_complement(dstp->bits, srcp->bits, nbits);
}



static inline __attribute__((no_instrument_function)) int __nodes_equal(con=
st nodemask_t *src1p,
     const nodemask_t *src2p, int nbits)
{
 return bitmap_equal(src1p->bits, src2p->bits, nbits);
}



static inline __attribute__((no_instrument_function)) int __nodes_intersect=
s(const nodemask_t *src1p,
     const nodemask_t *src2p, int nbits)
{
 return bitmap_intersects(src1p->bits, src2p->bits, nbits);
}



static inline __attribute__((no_instrument_function)) int __nodes_subset(co=
nst nodemask_t *src1p,
     const nodemask_t *src2p, int nbits)
{
 return bitmap_subset(src1p->bits, src2p->bits, nbits);
}


static inline __attribute__((no_instrument_function)) int __nodes_empty(con=
st nodemask_t *srcp, int nbits)
{
 return bitmap_empty(srcp->bits, nbits);
}


static inline __attribute__((no_instrument_function)) int __nodes_full(cons=
t nodemask_t *srcp, int nbits)
{
 return bitmap_full(srcp->bits, nbits);
}


static inline __attribute__((no_instrument_function)) int __nodes_weight(co=
nst nodemask_t *srcp, int nbits)
{
 return bitmap_weight(srcp->bits, nbits);
}



static inline __attribute__((no_instrument_function)) void __nodes_shift_ri=
ght(nodemask_t *dstp,
     const nodemask_t *srcp, int n, int nbits)
{
 bitmap_shift_right(dstp->bits, srcp->bits, n, nbits);
}



static inline __attribute__((no_instrument_function)) void __nodes_shift_le=
ft(nodemask_t *dstp,
     const nodemask_t *srcp, int n, int nbits)
{
 bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
}





static inline __attribute__((no_instrument_function)) int __first_node(cons=
t nodemask_t *srcp)
{
 return ({ int __min1 =3D ((1 << 0)); int __min2 =3D (find_first_bit(srcp->=
bits, (1 << 0))); __min1 < __min2 ? __min1: __min2; });
}


static inline __attribute__((no_instrument_function)) int __next_node(int n=
, const nodemask_t *srcp)
{
 return ({ int __min1 =3D ((1 << 0)); int __min2 =3D (find_next_bit(srcp->b=
its, (1 << 0), n+1)); __min1 < __min2 ? __min1: __min2; });
}

static inline __attribute__((no_instrument_function)) void init_nodemask_of=
_node(nodemask_t *mask, int node)
{
 __nodes_clear(&(*mask), (1 << 0));
 __node_set((node), &(*mask));
}
# 275 "/usr/src/linux-2.6/include/linux/nodemask.h"
static inline __attribute__((no_instrument_function)) int __first_unset_nod=
e(const nodemask_t *maskp)
{
 return ({ int __min1 =3D ((1 << 0)); int __min2 =3D (find_first_zero_bit(m=
askp->bits, (1 << 0))); __min1 < __min2 ? __min1: __min2; })
                                                  ;
}
# 309 "/usr/src/linux-2.6/include/linux/nodemask.h"
static inline __attribute__((no_instrument_function)) int __nodemask_scnpri=
ntf(char *buf, int len,
     const nodemask_t *srcp, int nbits)
{
 return bitmap_scnprintf(buf, len, srcp->bits, nbits);
}



static inline __attribute__((no_instrument_function)) int __nodemask_parse_=
user(const char *buf, int len,
     nodemask_t *dstp, int nbits)
{
 return bitmap_parse_user(buf, len, dstp->bits, nbits);
}



static inline __attribute__((no_instrument_function)) int __nodelist_scnpri=
ntf(char *buf, int len,
     const nodemask_t *srcp, int nbits)
{
 return bitmap_scnlistprintf(buf, len, srcp->bits, nbits);
}


static inline __attribute__((no_instrument_function)) int __nodelist_parse(=
const char *buf, nodemask_t *dstp, int nbits)
{
 return bitmap_parselist(buf, dstp->bits, nbits);
}



static inline __attribute__((no_instrument_function)) int __node_remap(int =
oldbit,
  const nodemask_t *oldp, const nodemask_t *newp, int nbits)
{
 return bitmap_bitremap(oldbit, oldp->bits, newp->bits, nbits);
}



static inline __attribute__((no_instrument_function)) void __nodes_remap(no=
demask_t *dstp, const nodemask_t *srcp,
  const nodemask_t *oldp, const nodemask_t *newp, int nbits)
{
 bitmap_remap(dstp->bits, srcp->bits, oldp->bits, newp->bits, nbits);
}



static inline __attribute__((no_instrument_function)) void __nodes_onto(nod=
emask_t *dstp, const nodemask_t *origp,
  const nodemask_t *relmapp, int nbits)
{
 bitmap_onto(dstp->bits, origp->bits, relmapp->bits, nbits);
}



static inline __attribute__((no_instrument_function)) void __nodes_fold(nod=
emask_t *dstp, const nodemask_t *origp,
  int sz, int nbits)
{
 bitmap_fold(dstp->bits, origp->bits, sz, nbits);
}
# 383 "/usr/src/linux-2.6/include/linux/nodemask.h"
enum node_states {
 N_POSSIBLE,
 N_ONLINE,
 N_NORMAL_MEMORY,

 N_HIGH_MEMORY,






 N_MEMORY =3D N_HIGH_MEMORY,

 N_CPU,
 NR_NODE_STATES
};






extern nodemask_t node_states[NR_NODE_STATES];
# 452 "/usr/src/linux-2.6/include/linux/nodemask.h"
static inline __attribute__((no_instrument_function)) int node_state(int no=
de, enum node_states state)
{
 return node =3D=3D 0;
}

static inline __attribute__((no_instrument_function)) void node_set_state(i=
nt node, enum node_states state)
{
}

static inline __attribute__((no_instrument_function)) void node_clear_state=
(int node, enum node_states state)
{
}

static inline __attribute__((no_instrument_function)) int num_node_state(en=
um node_states state)
{
 return 1;
}
# 486 "/usr/src/linux-2.6/include/linux/nodemask.h"
static inline __attribute__((no_instrument_function)) int node_random(const=
 nodemask_t *mask)
{
 return 0;
}
# 518 "/usr/src/linux-2.6/include/linux/nodemask.h"
struct nodemask_scratch {
 nodemask_t mask1;
 nodemask_t mask2;
};
# 24 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/mm_types.h" 1



# 1 "/usr/src/linux-2.6/include/linux/auxvec.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/auxvec.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/auxvec.h" 1
# 5 "/usr/src/linux-2.6/include/uapi/linux/auxvec.h" 2
# 5 "/usr/src/linux-2.6/include/linux/auxvec.h" 2
# 5 "/usr/src/linux-2.6/include/linux/mm_types.h" 2





# 1 "/usr/src/linux-2.6/include/linux/rwsem.h" 1
# 19 "/usr/src/linux-2.6/include/linux/rwsem.h"
struct rw_semaphore;





struct rw_semaphore {
 long count;
 raw_spinlock_t wait_lock;
 struct list_head wait_list;



};

extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem=
);
extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *se=
m);
extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);


# 1 "/usr/src/linux-2.6/arch/x86/include/asm/rwsem.h" 1
# 63 "/usr/src/linux-2.6/arch/x86/include/asm/rwsem.h"
static inline __attribute__((no_instrument_function)) void __down_read(stru=
ct rw_semaphore *sem)
{
 asm volatile("# beginning down_read\n\t"
       "" " " "incl" " " "(%1)\n\t"

       "  jns        1f\n"
       "  call call_rwsem_down_read_failed\n"
       "1:\n\t"
       "# ending down_read\n\t"
       : "+m" (sem->count)
       : "a" (sem)
       : "memory", "cc");
}




static inline __attribute__((no_instrument_function)) int __down_read_trylo=
ck(struct rw_semaphore *sem)
{
 long result, tmp;
 asm volatile("# beginning __down_read_trylock\n\t"
       "  mov          %0,%1\n\t"
       "1:\n\t"
       "  mov          %1,%2\n\t"
       "  add          %3,%2\n\t"
       "  jle	     2f\n\t"
       "" "  cmpxchg  %2,%0\n\t"
       "  jnz	     1b\n\t"
       "2:\n\t"
       "# ending __down_read_trylock\n\t"
       : "+m" (sem->count), "=3D&a" (result), "=3D&r" (tmp)
       : "i" (0x00000001L)
       : "memory", "cc");
 return result >=3D 0 ? 1 : 0;
}




static inline __attribute__((no_instrument_function)) void __down_write_nes=
ted(struct rw_semaphore *sem, int subclass)
{
 long tmp;
 asm volatile("# beginning down_write\n\t"
       "" "  xadd      %1,(%2)\n\t"

       "  test " " " "%w1" " " "," " " "%w1" " " "\n\t"

       "  jz        1f\n"
       "  call call_rwsem_down_write_failed\n"
       "1:\n"
       "# ending down_write"
       : "+m" (sem->count), "=3Dd" (tmp)
       : "a" (sem), "1" (((-0x0000ffffL -1) + 0x00000001L))
       : "memory", "cc");
}

static inline __attribute__((no_instrument_function)) void __down_write(str=
uct rw_semaphore *sem)
{
 __down_write_nested(sem, 0);
}




static inline __attribute__((no_instrument_function)) int __down_write_tryl=
ock(struct rw_semaphore *sem)
{
 long result, tmp;
 asm volatile("# beginning __down_write_trylock\n\t"
       "  mov          %0,%1\n\t"
       "1:\n\t"
       "  test " " " "%w1" " " "," " " "%w1" " " "\n\t"

       "  jnz          2f\n\t"
       "  mov          %1,%2\n\t"
       "  add          %3,%2\n\t"
       "" "  cmpxchg  %2,%0\n\t"
       "  jnz	     1b\n\t"
       "2:\n\t"
       "  sete         %b1\n\t"
       "  movzbl       %b1, %k1\n\t"
       "# ending __down_write_trylock\n\t"
       : "+m" (sem->count), "=3D&a" (result), "=3D&r" (tmp)
       : "er" (((-0x0000ffffL -1) + 0x00000001L))
       : "memory", "cc");
 return result;
}




static inline __attribute__((no_instrument_function)) void __up_read(struct=
 rw_semaphore *sem)
{
 long tmp;
 asm volatile("# beginning __up_read\n\t"
       "" "  xadd      %1,(%2)\n\t"

       "  jns        1f\n\t"
       "  call call_rwsem_wake\n"
       "1:\n"
       "# ending __up_read\n"
       : "+m" (sem->count), "=3Dd" (tmp)
       : "a" (sem), "1" (-0x00000001L)
       : "memory", "cc");
}




static inline __attribute__((no_instrument_function)) void __up_write(struc=
t rw_semaphore *sem)
{
 long tmp;
 asm volatile("# beginning __up_write\n\t"
       "" "  xadd      %1,(%2)\n\t"

       "  jns        1f\n\t"
       "  call call_rwsem_wake\n"
       "1:\n\t"
       "# ending __up_write\n"
       : "+m" (sem->count), "=3Dd" (tmp)
       : "a" (sem), "1" (-((-0x0000ffffL -1) + 0x00000001L))
       : "memory", "cc");
}




static inline __attribute__((no_instrument_function)) void __downgrade_writ=
e(struct rw_semaphore *sem)
{
 asm volatile("# beginning __downgrade_write\n\t"
       "" " " "addl" " " "%2,(%1)\n\t"




       "  jns       1f\n\t"
       "  call call_rwsem_downgrade_wake\n"
       "1:\n\t"
       "# ending __downgrade_write\n"
       : "+m" (sem->count)
       : "a" (sem), "er" (-(-0x0000ffffL -1))
       : "memory", "cc");
}




static inline __attribute__((no_instrument_function)) void rwsem_atomic_add=
(long delta, struct rw_semaphore *sem)
{
 asm volatile("" " " "addl" " " "%1,%0"
       : "+m" (sem->count)
       : "er" (delta));
}




static inline __attribute__((no_instrument_function)) long rwsem_atomic_upd=
ate(long delta, struct rw_semaphore *sem)
{
 return delta + ({ __typeof__ (*(((&sem->count)))) __ret =3D (((delta))); s=
witch (sizeof(*(((&sem->count))))) { case 1: asm volatile ("" "xadd" "b %b0=
, %1\n" : "+q" (__ret), "+m" (*(((&sem->count)))) : : "memory", "cc"); brea=
k; case 2: asm volatile ("" "xadd" "w %w0, %1\n" : "+r" (__ret), "+m" (*(((=
&sem->count)))) : : "memory", "cc"); break; case 4: asm volatile ("" "xadd"=
 "l %0, %1\n" : "+r" (__ret), "+m" (*(((&sem->count)))) : : "memory", "cc")=
; break; case -1: asm volatile ("" "xadd" "q %q0, %1\n" : "+r" (__ret), "+m=
" (*(((&sem->count)))) : : "memory", "cc"); break; default: __xadd_wrong_si=
ze(); } __ret; });
}
# 41 "/usr/src/linux-2.6/include/linux/rwsem.h" 2


static inline __attribute__((no_instrument_function)) int rwsem_is_locked(s=
truct rw_semaphore *sem)
{
 return sem->count !=3D 0;
}
# 67 "/usr/src/linux-2.6/include/linux/rwsem.h"
extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
    struct lock_class_key *key);
# 80 "/usr/src/linux-2.6/include/linux/rwsem.h"
extern void down_read(struct rw_semaphore *sem);




extern int down_read_trylock(struct rw_semaphore *sem);




extern void down_write(struct rw_semaphore *sem);




extern int down_write_trylock(struct rw_semaphore *sem);




extern void up_read(struct rw_semaphore *sem);




extern void up_write(struct rw_semaphore *sem);




extern void downgrade_write(struct rw_semaphore *sem);
# 11 "/usr/src/linux-2.6/include/linux/mm_types.h" 2
# 1 "/usr/src/linux-2.6/include/linux/completion.h" 1
# 11 "/usr/src/linux-2.6/include/linux/completion.h"
# 1 "/usr/src/linux-2.6/include/linux/wait.h" 1
# 10 "/usr/src/linux-2.6/include/linux/wait.h"
# 1 "/usr/src/linux-2.6/include/uapi/linux/wait.h" 1
# 11 "/usr/src/linux-2.6/include/linux/wait.h" 2

typedef struct __wait_queue wait_queue_t;
typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int fla=
gs, void *key);
int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, voi=
d *key);

struct __wait_queue {
 unsigned int flags;

 void *private;
 wait_queue_func_t func;
 struct list_head task_list;
};

struct wait_bit_key {
 void *flags;
 int bit_nr;

};

struct wait_bit_queue {
 struct wait_bit_key key;
 wait_queue_t wait;
};

struct __wait_queue_head {
 spinlock_t lock;
 struct list_head task_list;
};
typedef struct __wait_queue_head wait_queue_head_t;

struct task_struct;
# 68 "/usr/src/linux-2.6/include/linux/wait.h"
extern void __init_waitqueue_head(wait_queue_head_t *q, const char *name, s=
truct lock_class_key *);
# 86 "/usr/src/linux-2.6/include/linux/wait.h"
static inline __attribute__((no_instrument_function)) void init_waitqueue_e=
ntry(wait_queue_t *q, struct task_struct *p)
{
 q->flags =3D 0;
 q->private =3D p;
 q->func =3D default_wake_function;
}

static inline __attribute__((no_instrument_function)) void
init_waitqueue_func_entry(wait_queue_t *q, wait_queue_func_t func)
{
 q->flags =3D 0;
 q->private =3D ((void *)0);
 q->func =3D func;
}

static inline __attribute__((no_instrument_function)) int waitqueue_active(=
wait_queue_head_t *q)
{
 return !list_empty(&q->task_list);
}

extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wa=
it);
extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);

static inline __attribute__((no_instrument_function)) void __add_wait_queue=
(wait_queue_head_t *head, wait_queue_t *new)
{
 list_add(&new->task_list, &head->task_list);
}




static inline __attribute__((no_instrument_function)) void
__add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
{
 wait->flags |=3D 0x01;
 __add_wait_queue(q, wait);
}

static inline __attribute__((no_instrument_function)) void __add_wait_queue=
_tail(wait_queue_head_t *head,
      wait_queue_t *new)
{
 list_add_tail(&new->task_list, &head->task_list);
}

static inline __attribute__((no_instrument_function)) void
__add_wait_queue_tail_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
{
 wait->flags |=3D 0x01;
 __add_wait_queue_tail(q, wait);
}

static inline __attribute__((no_instrument_function)) void
__remove_wait_queue(wait_queue_head_t *head, wait_queue_t *old)
{
 list_del(&old->task_list);
}

void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *ke=
y);
void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, vo=
id *key);
void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
void __wake_up_bit(wait_queue_head_t *, void *, int);
int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(voi=
d *), unsigned);
int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*=
)(void *), unsigned);
void wake_up_bit(void *, int);
void wake_up_atomic_t(atomic_t *);
int out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned);
int out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned);
int out_of_line_wait_on_atomic_t(atomic_t *, int (*)(atomic_t *), unsigned);
wait_queue_head_t *bit_waitqueue(void *, int);
# 784 "/usr/src/linux-2.6/include/linux/wait.h"
extern void sleep_on(wait_queue_head_t *q);
extern long sleep_on_timeout(wait_queue_head_t *q, signed long timeout);
extern void interruptible_sleep_on(wait_queue_head_t *q);
extern long interruptible_sleep_on_timeout(wait_queue_head_t *q, signed lon=
g timeout);




void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, in=
t state);
void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait, unsigne=
d int mode, void *key);
int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, v=
oid *key);
int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *ke=
y);
# 841 "/usr/src/linux-2.6/include/linux/wait.h"
static inline __attribute__((no_instrument_function)) int
wait_on_bit(void *word, int bit, int (*action)(void *), unsigned mode)
{
 if (!(__builtin_constant_p((bit)) ? constant_test_bit((bit), (word)) : var=
iable_test_bit((bit), (word))))
  return 0;
 return out_of_line_wait_on_bit(word, bit, action, mode);
}
# 865 "/usr/src/linux-2.6/include/linux/wait.h"
static inline __attribute__((no_instrument_function)) int
wait_on_bit_lock(void *word, int bit, int (*action)(void *), unsigned mode)
{
 if (!test_and_set_bit(bit, word))
  return 0;
 return out_of_line_wait_on_bit_lock(word, bit, action, mode);
}
# 883 "/usr/src/linux-2.6/include/linux/wait.h"
static inline __attribute__((no_instrument_function))
int wait_on_atomic_t(atomic_t *val, int (*action)(atomic_t *), unsigned mod=
e)
{
 if (atomic_read(val) =3D=3D 0)
  return 0;
 return out_of_line_wait_on_atomic_t(val, action, mode);
}
# 12 "/usr/src/linux-2.6/include/linux/completion.h" 2
# 25 "/usr/src/linux-2.6/include/linux/completion.h"
struct completion {
 unsigned int done;
 wait_queue_head_t wait;
};
# 73 "/usr/src/linux-2.6/include/linux/completion.h"
static inline __attribute__((no_instrument_function)) void init_completion(=
struct completion *x)
{
 x->done =3D 0;
 do { static struct lock_class_key __key; __init_waitqueue_head((&x->wait),=
 "&x->wait", &__key); } while (0);
}

extern void wait_for_completion(struct completion *);
extern void wait_for_completion_io(struct completion *);
extern int wait_for_completion_interruptible(struct completion *x);
extern int wait_for_completion_killable(struct completion *x);
extern unsigned long wait_for_completion_timeout(struct completion *x,
         unsigned long timeout);
extern unsigned long wait_for_completion_io_timeout(struct completion *x,
          unsigned long timeout);
extern long wait_for_completion_interruptible_timeout(
 struct completion *x, unsigned long timeout);
extern long wait_for_completion_killable_timeout(
 struct completion *x, unsigned long timeout);
extern bool try_wait_for_completion(struct completion *x);
extern bool completion_done(struct completion *x);

extern void complete(struct completion *);
extern void complete_all(struct completion *);
# 12 "/usr/src/linux-2.6/include/linux/mm_types.h" 2

# 1 "/usr/src/linux-2.6/include/linux/page-debug-flags.h" 1
# 14 "/usr/src/linux-2.6/include/linux/page-debug-flags.h"
enum page_debug_flags {
 PAGE_DEBUG_FLAG_POISON,
 PAGE_DEBUG_FLAG_GUARD,
};
# 14 "/usr/src/linux-2.6/include/linux/mm_types.h" 2
# 1 "/usr/src/linux-2.6/include/linux/uprobes.h" 1
# 30 "/usr/src/linux-2.6/include/linux/uprobes.h"
struct vm_area_struct;
struct mm_struct;
struct inode;


# 1 "/usr/src/linux-2.6/arch/x86/include/asm/uprobes.h" 1
# 26 "/usr/src/linux-2.6/arch/x86/include/asm/uprobes.h"
# 1 "/usr/src/linux-2.6/include/linux/notifier.h" 1
# 13 "/usr/src/linux-2.6/include/linux/notifier.h"
# 1 "/usr/src/linux-2.6/include/linux/mutex.h" 1
# 49 "/usr/src/linux-2.6/include/linux/mutex.h"
struct mutex {

 atomic_t count;
 spinlock_t wait_lock;
 struct list_head wait_list;
# 67 "/usr/src/linux-2.6/include/linux/mutex.h"
};





struct mutex_waiter {
 struct list_head list;
 struct task_struct *task;



};
# 99 "/usr/src/linux-2.6/include/linux/mutex.h"
static inline __attribute__((no_instrument_function)) void mutex_destroy(st=
ruct mutex *lock) {}
# 119 "/usr/src/linux-2.6/include/linux/mutex.h"
extern void __mutex_init(struct mutex *lock, const char *name,
    struct lock_class_key *key);







static inline __attribute__((no_instrument_function)) int mutex_is_locked(s=
truct mutex *lock)
{
 return atomic_read(&lock->count) !=3D 1;
}
# 157 "/usr/src/linux-2.6/include/linux/mutex.h"
extern void mutex_lock(struct mutex *lock);
extern int __attribute__((warn_unused_result)) mutex_lock_interruptible(str=
uct mutex *lock);
extern int __attribute__((warn_unused_result)) mutex_lock_killable(struct m=
utex *lock);
# 173 "/usr/src/linux-2.6/include/linux/mutex.h"
extern int mutex_trylock(struct mutex *lock);
extern void mutex_unlock(struct mutex *lock);

extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
# 14 "/usr/src/linux-2.6/include/linux/notifier.h" 2

# 1 "/usr/src/linux-2.6/include/linux/srcu.h" 1
# 33 "/usr/src/linux-2.6/include/linux/srcu.h"
# 1 "/usr/src/linux-2.6/include/linux/rcupdate.h" 1
# 44 "/usr/src/linux-2.6/include/linux/rcupdate.h"
# 1 "/usr/src/linux-2.6/include/linux/debugobjects.h" 1






enum debug_obj_state {
 ODEBUG_STATE_NONE,
 ODEBUG_STATE_INIT,
 ODEBUG_STATE_INACTIVE,
 ODEBUG_STATE_ACTIVE,
 ODEBUG_STATE_DESTROYED,
 ODEBUG_STATE_NOTAVAILABLE,
 ODEBUG_STATE_MAX,
};

struct debug_obj_descr;
# 27 "/usr/src/linux-2.6/include/linux/debugobjects.h"
struct debug_obj {
 struct hlist_node node;
 enum debug_obj_state state;
 unsigned int astate;
 void *object;
 struct debug_obj_descr *descr;
};
# 52 "/usr/src/linux-2.6/include/linux/debugobjects.h"
struct debug_obj_descr {
 const char *name;
 void *(*debug_hint) (void *addr);
 int (*fixup_init) (void *addr, enum debug_obj_state state);
 int (*fixup_activate) (void *addr, enum debug_obj_state state);
 int (*fixup_destroy) (void *addr, enum debug_obj_state state);
 int (*fixup_free) (void *addr, enum debug_obj_state state);
 int (*fixup_assert_init)(void *addr, enum debug_obj_state state);
};
# 84 "/usr/src/linux-2.6/include/linux/debugobjects.h"
static inline __attribute__((no_instrument_function)) void
debug_object_init (void *addr, struct debug_obj_descr *descr) { }
static inline __attribute__((no_instrument_function)) void
debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr) { }
static inline __attribute__((no_instrument_function)) int
debug_object_activate (void *addr, struct debug_obj_descr *descr) { return =
0; }
static inline __attribute__((no_instrument_function)) void
debug_object_deactivate(void *addr, struct debug_obj_descr *descr) { }
static inline __attribute__((no_instrument_function)) void
debug_object_destroy (void *addr, struct debug_obj_descr *descr) { }
static inline __attribute__((no_instrument_function)) void
debug_object_free (void *addr, struct debug_obj_descr *descr) { }
static inline __attribute__((no_instrument_function)) void
debug_object_assert_init(void *addr, struct debug_obj_descr *descr) { }

static inline __attribute__((no_instrument_function)) void debug_objects_ea=
rly_init(void) { }
static inline __attribute__((no_instrument_function)) void debug_objects_me=
m_init(void) { }





static inline __attribute__((no_instrument_function)) void
debug_check_no_obj_freed(const void *address, unsigned long size) { }
# 45 "/usr/src/linux-2.6/include/linux/rcupdate.h" 2
# 61 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) void rcutorture_recor=
d_test_transition(void)
{
}
static inline __attribute__((no_instrument_function)) void rcutorture_recor=
d_progress(unsigned long vernum)
{
}
# 152 "/usr/src/linux-2.6/include/linux/rcupdate.h"
extern void call_rcu_bh(struct callback_head *head,
   void (*func)(struct callback_head *head));
# 174 "/usr/src/linux-2.6/include/linux/rcupdate.h"
extern void call_rcu_sched(struct callback_head *head,
      void (*func)(struct callback_head *rcu));

extern void synchronize_sched(void);
# 196 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) void __rcu_read_lock(=
void)
{
 __asm__ __volatile__("": : :"memory");
}

static inline __attribute__((no_instrument_function)) void __rcu_read_unloc=
k(void)
{
 __asm__ __volatile__("": : :"memory");
}

static inline __attribute__((no_instrument_function)) void synchronize_rcu(=
void)
{
 synchronize_sched();
}

static inline __attribute__((no_instrument_function)) int rcu_preempt_depth=
(void)
{
 return 0;
}




extern void rcu_init(void);
extern void rcu_sched_qs(int cpu);
extern void rcu_bh_qs(int cpu);
extern void rcu_check_callbacks(int cpu, int user);
struct notifier_block;
extern void rcu_idle_enter(void);
extern void rcu_idle_exit(void);
extern void rcu_irq_enter(void);
extern void rcu_irq_exit(void);





static inline __attribute__((no_instrument_function)) void rcu_user_enter(v=
oid) { }
static inline __attribute__((no_instrument_function)) void rcu_user_exit(vo=
id) { }
static inline __attribute__((no_instrument_function)) void rcu_user_hooks_s=
witch(struct task_struct *prev,
      struct task_struct *next) { }
# 269 "/usr/src/linux-2.6/include/linux/rcupdate.h"
typedef void call_rcu_func_t(struct callback_head *head,
        void (*func)(struct callback_head *head));
void wait_rcu_gp(call_rcu_func_t crf);




# 1 "/usr/src/linux-2.6/include/linux/rcutiny.h" 1
# 30 "/usr/src/linux-2.6/include/linux/rcutiny.h"
static inline __attribute__((no_instrument_function)) void rcu_barrier_bh(v=
oid)
{
 wait_rcu_gp(call_rcu_bh);
}

static inline __attribute__((no_instrument_function)) void rcu_barrier_sche=
d(void)
{
 wait_rcu_gp(call_rcu_sched);
}

static inline __attribute__((no_instrument_function)) void synchronize_rcu_=
expedited(void)
{
 synchronize_sched();
}

static inline __attribute__((no_instrument_function)) void rcu_barrier(void)
{
 rcu_barrier_sched();
}

static inline __attribute__((no_instrument_function)) void synchronize_rcu_=
bh(void)
{
 synchronize_sched();
}

static inline __attribute__((no_instrument_function)) void synchronize_rcu_=
bh_expedited(void)
{
 synchronize_sched();
}

static inline __attribute__((no_instrument_function)) void synchronize_sche=
d_expedited(void)
{
 synchronize_sched();
}

static inline __attribute__((no_instrument_function)) void kfree_call_rcu(s=
truct callback_head *head,
      void (*func)(struct callback_head *rcu))
{
 call_rcu_sched(head, func);
}

static inline __attribute__((no_instrument_function)) int rcu_needs_cpu(int=
 cpu, unsigned long *delta_jiffies)
{
 *delta_jiffies =3D (~0UL);
 return 0;
}

static inline __attribute__((no_instrument_function)) void rcu_note_context=
_switch(int cpu)
{
 rcu_sched_qs(cpu);
}





static inline __attribute__((no_instrument_function)) void rcu_virt_note_co=
ntext_switch(int cpu)
{
}




static inline __attribute__((no_instrument_function)) long rcu_batches_comp=
leted(void)
{
 return 0;
}




static inline __attribute__((no_instrument_function)) long rcu_batches_comp=
leted_bh(void)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) void rcu_force_quiesc=
ent_state(void)
{
}

static inline __attribute__((no_instrument_function)) void rcu_bh_force_qui=
escent_state(void)
{
}

static inline __attribute__((no_instrument_function)) void rcu_sched_force_=
quiescent_state(void)
{
}

static inline __attribute__((no_instrument_function)) void rcu_cpu_stall_re=
set(void)
{
}

static inline __attribute__((no_instrument_function)) void exit_rcu(void)
{
}





static inline __attribute__((no_instrument_function)) void rcu_scheduler_st=
arting(void)
{
}
# 277 "/usr/src/linux-2.6/include/linux/rcupdate.h" 2
# 291 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) void init_rcu_head_on=
_stack(struct callback_head *head)
{
}

static inline __attribute__((no_instrument_function)) void destroy_rcu_head=
_on_stack(struct callback_head *head)
{
}
# 307 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) bool rcu_lockdep_curr=
ent_cpu_online(void)
{
 return 1;
}
# 425 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) int rcu_read_lock_hel=
d(void)
{
 return 1;
}

static inline __attribute__((no_instrument_function)) int rcu_read_lock_bh_=
held(void)
{
 return 1;
}







static inline __attribute__((no_instrument_function)) int rcu_read_lock_sch=
ed_held(void)
{
 return 1;
}
# 769 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) void rcu_read_lock(vo=
id)
{
 __rcu_read_lock();
 (void)0;
 do { } while (0);
 do { } while (0)
                                                  ;
}
# 793 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) void rcu_read_unlock(=
void)
{
 do { } while (0)
                                                    ;
 do { } while (0);
 (void)0;
 __rcu_read_unlock();
}
# 819 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) void rcu_read_lock_bh=
(void)
{
 local_bh_disable();
 (void)0;
 do { } while (0);
 do { } while (0)
                                                     ;
}






static inline __attribute__((no_instrument_function)) void rcu_read_unlock_=
bh(void)
{
 do { } while (0)
                                                       ;
 do { } while (0);
 (void)0;
 local_bh_enable();
}
# 855 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) void rcu_read_lock_sc=
hed(void)
{
 __asm__ __volatile__("": : :"memory");
 (void)0;
 do { } while (0);
 do { } while (0)
                                                        ;
}


static inline __attribute__((no_instrument_function)) __attribute__((no_ins=
trument_function)) void rcu_read_lock_sched_notrace(void)
{
 __asm__ __volatile__("": : :"memory");
 (void)0;
}






static inline __attribute__((no_instrument_function)) void rcu_read_unlock_=
sched(void)
{
 do { } while (0)
                                                          ;
 do { } while (0);
 (void)0;
 __asm__ __volatile__("": : :"memory");
}


static inline __attribute__((no_instrument_function)) __attribute__((no_ins=
trument_function)) void rcu_read_unlock_sched_notrace(void)
{
 (void)0;
 __asm__ __volatile__("": : :"memory");
}
# 1010 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) bool rcu_is_nocb_cpu(=
int cpu) { return false; }
# 1020 "/usr/src/linux-2.6/include/linux/rcupdate.h"
static inline __attribute__((no_instrument_function)) bool rcu_sys_is_idle(=
void)
{
 return false;
}

static inline __attribute__((no_instrument_function)) void rcu_sysidle_forc=
e_exit(void)
{
}
# 34 "/usr/src/linux-2.6/include/linux/srcu.h" 2
# 1 "/usr/src/linux-2.6/include/linux/workqueue.h" 1







# 1 "/usr/src/linux-2.6/include/linux/timer.h" 1




# 1 "/usr/src/linux-2.6/include/linux/ktime.h" 1
# 46 "/usr/src/linux-2.6/include/linux/ktime.h"
union ktime {
 s64 tv64;
# 57 "/usr/src/linux-2.6/include/linux/ktime.h"
};

typedef union ktime ktime_t;
# 74 "/usr/src/linux-2.6/include/linux/ktime.h"
static inline __attribute__((no_instrument_function)) ktime_t ktime_set(con=
st long secs, const unsigned long nsecs)
{




 return (ktime_t) { .tv64 =3D (s64)secs * 1000000000L + (s64)nsecs };
}
# 106 "/usr/src/linux-2.6/include/linux/ktime.h"
static inline __attribute__((no_instrument_function)) ktime_t timespec_to_k=
time(struct timespec ts)
{
 return ktime_set(ts.tv_sec, ts.tv_nsec);
}


static inline __attribute__((no_instrument_function)) ktime_t timeval_to_kt=
ime(struct timeval tv)
{
 return ktime_set(tv.tv_sec, tv.tv_usec * 1000L);
}
# 283 "/usr/src/linux-2.6/include/linux/ktime.h"
static inline __attribute__((no_instrument_function)) int ktime_equal(const=
 ktime_t cmp1, const ktime_t cmp2)
{
 return cmp1.tv64 =3D=3D cmp2.tv64;
}
# 298 "/usr/src/linux-2.6/include/linux/ktime.h"
static inline __attribute__((no_instrument_function)) int ktime_compare(con=
st ktime_t cmp1, const ktime_t cmp2)
{
 if (cmp1.tv64 < cmp2.tv64)
  return -1;
 if (cmp1.tv64 > cmp2.tv64)
  return 1;
 return 0;
}

static inline __attribute__((no_instrument_function)) s64 ktime_to_us(const=
 ktime_t kt)
{
 struct timeval tv =3D ns_to_timeval((kt).tv64);
 return (s64) tv.tv_sec * 1000000L + tv.tv_usec;
}

static inline __attribute__((no_instrument_function)) s64 ktime_to_ms(const=
 ktime_t kt)
{
 struct timeval tv =3D ns_to_timeval((kt).tv64);
 return (s64) tv.tv_sec * 1000L + tv.tv_usec / 1000L;
}

static inline __attribute__((no_instrument_function)) s64 ktime_us_delta(co=
nst ktime_t later, const ktime_t earlier)
{
       return ktime_to_us(({ (ktime_t){ .tv64 =3D (later).tv64 - (earlier).=
tv64 }; }));
}

static inline __attribute__((no_instrument_function)) ktime_t ktime_add_us(=
const ktime_t kt, const u64 usec)
{
 return ({ (ktime_t){ .tv64 =3D (kt).tv64 + (usec * 1000L) }; });
}

static inline __attribute__((no_instrument_function)) ktime_t ktime_add_ms(=
const ktime_t kt, const u64 msec)
{
 return ({ (ktime_t){ .tv64 =3D (kt).tv64 + (msec * 1000000L) }; });
}

static inline __attribute__((no_instrument_function)) ktime_t ktime_sub_us(=
const ktime_t kt, const u64 usec)
{
 return ({ (ktime_t){ .tv64 =3D (kt).tv64 - (usec * 1000L) }; });
}

extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
# 349 "/usr/src/linux-2.6/include/linux/ktime.h"
static inline __attribute__((no_instrument_function)) __attribute__((warn_u=
nused_result)) bool ktime_to_timespec_cond(const ktime_t kt,
             struct timespec *ts)
{
 if (kt.tv64) {
  *ts =3D ns_to_timespec((kt).tv64);
  return true;
 } else {
  return false;
 }
}
# 370 "/usr/src/linux-2.6/include/linux/ktime.h"
extern void ktime_get_ts(struct timespec *ts);




static inline __attribute__((no_instrument_function)) ktime_t ns_to_ktime(u=
64 ns)
{
 static const ktime_t ktime_zero =3D { .tv64 =3D 0 };

 return ({ (ktime_t){ .tv64 =3D (ktime_zero).tv64 + (ns) }; });
}

static inline __attribute__((no_instrument_function)) ktime_t ms_to_ktime(u=
64 ms)
{
 static const ktime_t ktime_zero =3D { .tv64 =3D 0 };

 return ktime_add_ms(ktime_zero, ms);
}
# 6 "/usr/src/linux-2.6/include/linux/timer.h" 2




struct tvec_base;

struct timer_list {




 struct list_head entry;
 unsigned long expires;
 struct tvec_base *base;

 void (*function)(unsigned long);
 unsigned long data;

 int slack;


 int start_pid;
 void *start_site;
 char start_comm[16];




};

extern struct tvec_base boot_tvec_bases;
# 94 "/usr/src/linux-2.6/include/linux/timer.h"
void init_timer_key(struct timer_list *timer, unsigned int flags,
      const char *name, struct lock_class_key *key);







static inline __attribute__((no_instrument_function)) void destroy_timer_on=
_stack(struct timer_list *timer) { }
static inline __attribute__((no_instrument_function)) void init_timer_on_st=
ack_key(struct timer_list *timer,
        unsigned int flags, const char *name,
        struct lock_class_key *key)
{
 init_timer_key(timer, flags, name, key);
}
# 169 "/usr/src/linux-2.6/include/linux/timer.h"
static inline __attribute__((no_instrument_function)) int timer_pending(con=
st struct timer_list * timer)
{
 return timer->entry.next !=3D ((void *)0);
}

extern void add_timer_on(struct timer_list *timer, int cpu);
extern int del_timer(struct timer_list * timer);
extern int mod_timer(struct timer_list *timer, unsigned long expires);
extern int mod_timer_pending(struct timer_list *timer, unsigned long expire=
s);
extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires=
);

extern void set_timer_slack(struct timer_list *time, int slack_hz);
# 195 "/usr/src/linux-2.6/include/linux/timer.h"
extern unsigned long get_next_timer_interrupt(unsigned long now);






extern int timer_stats_active;



extern void init_timer_stats(void);

extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
         void *timerf, char *comm,
         unsigned int timer_flag);

extern void __timer_stats_timer_set_start_info(struct timer_list *timer,
            void *addr);

static inline __attribute__((no_instrument_function)) void timer_stats_time=
r_set_start_info(struct timer_list *timer)
{
 if (__builtin_expect(!!(!timer_stats_active), 1))
  return;
 __timer_stats_timer_set_start_info(timer, __builtin_return_address(0));
}

static inline __attribute__((no_instrument_function)) void timer_stats_time=
r_clear_start_info(struct timer_list *timer)
{
 timer->start_site =3D ((void *)0);
}
# 240 "/usr/src/linux-2.6/include/linux/timer.h"
extern void add_timer(struct timer_list *timer);

extern int try_to_del_timer_sync(struct timer_list *timer);
# 252 "/usr/src/linux-2.6/include/linux/timer.h"
extern void init_timers(void);
extern void run_local_timers(void);
struct hrtimer;
extern enum hrtimer_restart it_real_fn(struct hrtimer *);

unsigned long __round_jiffies(unsigned long j, int cpu);
unsigned long __round_jiffies_relative(unsigned long j, int cpu);
unsigned long round_jiffies(unsigned long j);
unsigned long round_jiffies_relative(unsigned long j);

unsigned long __round_jiffies_up(unsigned long j, int cpu);
unsigned long __round_jiffies_up_relative(unsigned long j, int cpu);
unsigned long round_jiffies_up(unsigned long j);
unsigned long round_jiffies_up_relative(unsigned long j);
# 9 "/usr/src/linux-2.6/include/linux/workqueue.h" 2







struct workqueue_struct;

struct work_struct;
typedef void (*work_func_t)(struct work_struct *work);
void delayed_work_timer_fn(unsigned long __data);







enum {
 WORK_STRUCT_PENDING_BIT =3D 0,
 WORK_STRUCT_DELAYED_BIT =3D 1,
 WORK_STRUCT_PWQ_BIT =3D 2,
 WORK_STRUCT_LINKED_BIT =3D 3,




 WORK_STRUCT_COLOR_SHIFT =3D 4,


 WORK_STRUCT_COLOR_BITS =3D 4,

 WORK_STRUCT_PENDING =3D 1 << WORK_STRUCT_PENDING_BIT,
 WORK_STRUCT_DELAYED =3D 1 << WORK_STRUCT_DELAYED_BIT,
 WORK_STRUCT_PWQ =3D 1 << WORK_STRUCT_PWQ_BIT,
 WORK_STRUCT_LINKED =3D 1 << WORK_STRUCT_LINKED_BIT,



 WORK_STRUCT_STATIC =3D 0,






 WORK_NR_COLORS =3D (1 << WORK_STRUCT_COLOR_BITS) - 1,
 WORK_NO_COLOR =3D WORK_NR_COLORS,


 WORK_CPU_UNBOUND =3D 1,
 WORK_CPU_END =3D 1 + 1,






 WORK_STRUCT_FLAG_BITS =3D WORK_STRUCT_COLOR_SHIFT +
      WORK_STRUCT_COLOR_BITS,


 WORK_OFFQ_FLAG_BASE =3D WORK_STRUCT_COLOR_SHIFT,

 WORK_OFFQ_CANCELING =3D (1 << WORK_OFFQ_FLAG_BASE),






 WORK_OFFQ_FLAG_BITS =3D 1,
 WORK_OFFQ_POOL_SHIFT =3D WORK_OFFQ_FLAG_BASE + WORK_OFFQ_FLAG_BITS,
 WORK_OFFQ_LEFT =3D 32 - WORK_OFFQ_POOL_SHIFT,
 WORK_OFFQ_POOL_BITS =3D WORK_OFFQ_LEFT <=3D 31 ? WORK_OFFQ_LEFT : 31,
 WORK_OFFQ_POOL_NONE =3D (1LU << WORK_OFFQ_POOL_BITS) - 1,


 WORK_STRUCT_FLAG_MASK =3D (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 WORK_STRUCT_WQ_DATA_MASK =3D ~WORK_STRUCT_FLAG_MASK,
 WORK_STRUCT_NO_POOL =3D (unsigned long)WORK_OFFQ_POOL_NONE << WORK_OFFQ_PO=
OL_SHIFT,


 WORK_BUSY_PENDING =3D 1 << 0,
 WORK_BUSY_RUNNING =3D 1 << 1,


 WORKER_DESC_LEN =3D 24,
};

struct work_struct {
 atomic_long_t data;
 struct list_head entry;
 work_func_t func;



};





struct delayed_work {
 struct work_struct work;
 struct timer_list timer;


 struct workqueue_struct *wq;
 int cpu;
};
# 130 "/usr/src/linux-2.6/include/linux/workqueue.h"
struct workqueue_attrs {
 int nice;
 cpumask_var_t cpumask;
 bool no_numa;
};

static inline __attribute__((no_instrument_function)) struct delayed_work *=
to_delayed_work(struct work_struct *work)
{
 return ({ const typeof( ((struct delayed_work *)0)->work ) *__mptr =3D (wo=
rk); (struct delayed_work *)( (char *)__mptr - __builtin_offsetof(struct de=
layed_work,work) );});
}

struct execute_work {
 struct work_struct work;
};
# 199 "/usr/src/linux-2.6/include/linux/workqueue.h"
static inline __attribute__((no_instrument_function)) void __init_work(stru=
ct work_struct *work, int onstack) { }
static inline __attribute__((no_instrument_function)) void destroy_work_on_=
stack(struct work_struct *work) { }
static inline __attribute__((no_instrument_function)) unsigned int work_sta=
tic(struct work_struct *work) { return 0; }
# 297 "/usr/src/linux-2.6/include/linux/workqueue.h"
enum {




 WQ_NON_REENTRANT =3D 1 << 0,

 WQ_UNBOUND =3D 1 << 1,
 WQ_FREEZABLE =3D 1 << 2,
 WQ_MEM_RECLAIM =3D 1 << 3,
 WQ_HIGHPRI =3D 1 << 4,
 WQ_CPU_INTENSIVE =3D 1 << 5,
 WQ_SYSFS =3D 1 << 6,
# 336 "/usr/src/linux-2.6/include/linux/workqueue.h"
 WQ_POWER_EFFICIENT =3D 1 << 7,

 __WQ_DRAINING =3D 1 << 16,
 __WQ_ORDERED =3D 1 << 17,

 WQ_MAX_ACTIVE =3D 512,
 WQ_MAX_UNBOUND_PER_CPU =3D 4,
 WQ_DFL_ACTIVE =3D WQ_MAX_ACTIVE / 2,
};
# 375 "/usr/src/linux-2.6/include/linux/workqueue.h"
extern struct workqueue_struct *system_wq;
extern struct workqueue_struct *system_long_wq;
extern struct workqueue_struct *system_unbound_wq;
extern struct workqueue_struct *system_freezable_wq;
extern struct workqueue_struct *system_power_efficient_wq;
extern struct workqueue_struct *system_freezable_power_efficient_wq;

static inline __attribute__((no_instrument_function)) struct workqueue_stru=
ct * __system_nrt_wq(void)
{
 return system_wq;
}

static inline __attribute__((no_instrument_function)) struct workqueue_stru=
ct * __system_nrt_freezable_wq(void)
{
 return system_freezable_wq;
}





extern struct workqueue_struct *
__alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 struct lock_class_key *key, const char *lock_name, ...) __attribute__((for=
mat(printf, 1, 6)));
# 460 "/usr/src/linux-2.6/include/linux/workqueue.h"
extern void destroy_workqueue(struct workqueue_struct *wq);

struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask);
void free_workqueue_attrs(struct workqueue_attrs *attrs);
int apply_workqueue_attrs(struct workqueue_struct *wq,
     const struct workqueue_attrs *attrs);

extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
   struct work_struct *work);
extern bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
   struct delayed_work *work, unsigned long delay);
extern bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
   struct delayed_work *dwork, unsigned long delay);

extern void flush_workqueue(struct workqueue_struct *wq);
extern void drain_workqueue(struct workqueue_struct *wq);
extern void flush_scheduled_work(void);

extern int schedule_on_each_cpu(work_func_t func);

int execute_in_process_context(work_func_t fn, struct execute_work *);

extern bool flush_work(struct work_struct *work);
extern bool cancel_work_sync(struct work_struct *work);

extern bool flush_delayed_work(struct delayed_work *dwork);
extern bool cancel_delayed_work(struct delayed_work *dwork);
extern bool cancel_delayed_work_sync(struct delayed_work *dwork);

extern void workqueue_set_max_active(struct workqueue_struct *wq,
         int max_active);
extern bool current_is_workqueue_rescuer(void);
extern bool workqueue_congested(int cpu, struct workqueue_struct *wq);
extern unsigned int work_busy(struct work_struct *work);
extern __attribute__((format(printf, 1, 2))) void set_worker_desc(const cha=
r *fmt, ...);
extern void print_worker_info(const char *log_lvl, struct task_struct *task=
);
# 507 "/usr/src/linux-2.6/include/linux/workqueue.h"
static inline __attribute__((no_instrument_function)) bool queue_work(struc=
t workqueue_struct *wq,
         struct work_struct *work)
{
 return queue_work_on(WORK_CPU_UNBOUND, wq, work);
}
# 521 "/usr/src/linux-2.6/include/linux/workqueue.h"
static inline __attribute__((no_instrument_function)) bool queue_delayed_wo=
rk(struct workqueue_struct *wq,
          struct delayed_work *dwork,
          unsigned long delay)
{
 return queue_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
}
# 536 "/usr/src/linux-2.6/include/linux/workqueue.h"
static inline __attribute__((no_instrument_function)) bool mod_delayed_work=
(struct workqueue_struct *wq,
        struct delayed_work *dwork,
        unsigned long delay)
{
 return mod_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
}
# 550 "/usr/src/linux-2.6/include/linux/workqueue.h"
static inline __attribute__((no_instrument_function)) bool schedule_work_on=
(int cpu, struct work_struct *work)
{
 return queue_work_on(cpu, system_wq, work);
}
# 566 "/usr/src/linux-2.6/include/linux/workqueue.h"
static inline __attribute__((no_instrument_function)) bool schedule_work(st=
ruct work_struct *work)
{
 return queue_work(system_wq, work);
}
# 580 "/usr/src/linux-2.6/include/linux/workqueue.h"
static inline __attribute__((no_instrument_function)) bool schedule_delayed=
_work_on(int cpu, struct delayed_work *dwork,
         unsigned long delay)
{
 return queue_delayed_work_on(cpu, system_wq, dwork, delay);
}
# 594 "/usr/src/linux-2.6/include/linux/workqueue.h"
static inline __attribute__((no_instrument_function)) bool schedule_delayed=
_work(struct delayed_work *dwork,
      unsigned long delay)
{
 return queue_delayed_work(system_wq, dwork, delay);
}




static inline __attribute__((no_instrument_function)) bool keventd_up(void)
{
 return system_wq !=3D ((void *)0);
}






static inline __attribute__((no_instrument_function)) bool __cancel_delayed=
_work(struct delayed_work *work)
{
 bool ret;

 ret =3D del_timer(&work->timer);
 if (ret)
  clear_bit(WORK_STRUCT_PENDING_BIT, ((unsigned long *)(&(&work->work)->dat=
a)));
 return ret;
}


static inline __attribute__((no_instrument_function)) bool flush_work_sync(=
struct work_struct *work)
{
 return flush_work(work);
}


static inline __attribute__((no_instrument_function)) bool flush_delayed_wo=
rk_sync(struct delayed_work *dwork)
{
 return flush_delayed_work(dwork);
}


static inline __attribute__((no_instrument_function)) long work_on_cpu(int =
cpu, long (*fn)(void *), void *arg)
{
 return fn(arg);
}





extern void freeze_workqueues_begin(void);
extern bool freeze_workqueues_busy(void);
extern void thaw_workqueues(void);



int workqueue_sysfs_register(struct workqueue_struct *wq);
# 35 "/usr/src/linux-2.6/include/linux/srcu.h" 2

struct srcu_struct_array {
 unsigned long c[2];
 unsigned long seq[2];
};

struct rcu_batch {
 struct callback_head *head, **tail;
};



struct srcu_struct {
 unsigned completed;
 struct srcu_struct_array *per_cpu_ref;
 spinlock_t queue_lock;
 bool running;

 struct rcu_batch batch_queue;

 struct rcu_batch batch_check0;

 struct rcu_batch batch_check1;
 struct rcu_batch batch_done;
 struct delayed_work work;



};
# 80 "/usr/src/linux-2.6/include/linux/srcu.h"
int init_srcu_struct(struct srcu_struct *sp);




void process_srcu(struct work_struct *work);
# 130 "/usr/src/linux-2.6/include/linux/srcu.h"
void call_srcu(struct srcu_struct *sp, struct callback_head *head,
  void (*func)(struct callback_head *head));

void cleanup_srcu_struct(struct srcu_struct *sp);
int __srcu_read_lock(struct srcu_struct *sp) ;
void __srcu_read_unlock(struct srcu_struct *sp, int idx) ;
void synchronize_srcu(struct srcu_struct *sp);
void synchronize_srcu_expedited(struct srcu_struct *sp);
long srcu_batches_completed(struct srcu_struct *sp);
void srcu_barrier(struct srcu_struct *sp);
# 167 "/usr/src/linux-2.6/include/linux/srcu.h"
static inline __attribute__((no_instrument_function)) int srcu_read_lock_he=
ld(struct srcu_struct *sp)
{
 return 1;
}
# 218 "/usr/src/linux-2.6/include/linux/srcu.h"
static inline __attribute__((no_instrument_function)) int srcu_read_lock(st=
ruct srcu_struct *sp)
{
 int retval =3D __srcu_read_lock(sp);

 do { } while (0);
 return retval;
}
# 233 "/usr/src/linux-2.6/include/linux/srcu.h"
static inline __attribute__((no_instrument_function)) void srcu_read_unlock=
(struct srcu_struct *sp, int idx)

{
 do { } while (0);
 __srcu_read_unlock(sp, idx);
}
# 16 "/usr/src/linux-2.6/include/linux/notifier.h" 2
# 50 "/usr/src/linux-2.6/include/linux/notifier.h"
typedef int (*notifier_fn_t)(struct notifier_block *nb,
   unsigned long action, void *data);

struct notifier_block {
 notifier_fn_t notifier_call;
 struct notifier_block *next;
 int priority;
};

struct atomic_notifier_head {
 spinlock_t lock;
 struct notifier_block *head;
};

struct blocking_notifier_head {
 struct rw_semaphore rwsem;
 struct notifier_block *head;
};

struct raw_notifier_head {
 struct notifier_block *head;
};

struct srcu_notifier_head {
 struct mutex mutex;
 struct srcu_struct srcu;
 struct notifier_block *head;
};
# 92 "/usr/src/linux-2.6/include/linux/notifier.h"
extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
# 118 "/usr/src/linux-2.6/include/linux/notifier.h"
extern int atomic_notifier_chain_register(struct atomic_notifier_head *nh,
  struct notifier_block *nb);
extern int blocking_notifier_chain_register(struct blocking_notifier_head *=
nh,
  struct notifier_block *nb);
extern int raw_notifier_chain_register(struct raw_notifier_head *nh,
  struct notifier_block *nb);
extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
  struct notifier_block *nb);

extern int blocking_notifier_chain_cond_register(
  struct blocking_notifier_head *nh,
  struct notifier_block *nb);

extern int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
  struct notifier_block *nb);
extern int blocking_notifier_chain_unregister(struct blocking_notifier_head=
 *nh,
  struct notifier_block *nb);
extern int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
  struct notifier_block *nb);
extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *nh,
  struct notifier_block *nb);

extern int atomic_notifier_call_chain(struct atomic_notifier_head *nh,
  unsigned long val, void *v);
extern int __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 unsigned long val, void *v, int nr_to_call, int *nr_calls);
extern int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
  unsigned long val, void *v);
extern int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 unsigned long val, void *v, int nr_to_call, int *nr_calls);
extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
  unsigned long val, void *v);
extern int __raw_notifier_call_chain(struct raw_notifier_head *nh,
 unsigned long val, void *v, int nr_to_call, int *nr_calls);
extern int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
  unsigned long val, void *v);
extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 unsigned long val, void *v, int nr_to_call, int *nr_calls);
# 168 "/usr/src/linux-2.6/include/linux/notifier.h"
static inline __attribute__((no_instrument_function)) int notifier_from_err=
no(int err)
{
 if (err)
  return 0x8000 | (0x0001 - err);

 return 0x0001;
}


static inline __attribute__((no_instrument_function)) int notifier_to_errno=
(int ret)
{
 ret &=3D ~0x8000;
 return ret > 0x0001 ? 0x0001 - ret : 0;
}
# 212 "/usr/src/linux-2.6/include/linux/notifier.h"
extern struct blocking_notifier_head reboot_notifier_list;
# 27 "/usr/src/linux-2.6/arch/x86/include/asm/uprobes.h" 2

typedef u8 uprobe_opcode_t;







struct arch_uprobe {
 u16 fixups;
 u8 insn[16];



};

struct arch_uprobe_task {



 unsigned int saved_trap_nr;
 unsigned int saved_tf;
};

extern int arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_stru=
ct *mm, unsigned long addr);
extern int arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *reg=
s);
extern int arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *re=
gs);
extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
extern int arch_uprobe_exception_notify(struct notifier_block *self, unsign=
ed long val, void *data);
extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *=
regs);
extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampo=
line_vaddr, struct pt_regs *regs);
# 36 "/usr/src/linux-2.6/include/linux/uprobes.h" 2







enum uprobe_filter_ctx {
 UPROBE_FILTER_REGISTER,
 UPROBE_FILTER_UNREGISTER,
 UPROBE_FILTER_MMAP,
};

struct uprobe_consumer {
 int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
 int (*ret_handler)(struct uprobe_consumer *self,
    unsigned long func,
    struct pt_regs *regs);
 bool (*filter)(struct uprobe_consumer *self,
    enum uprobe_filter_ctx ctx,
    struct mm_struct *mm);

 struct uprobe_consumer *next;
};
# 129 "/usr/src/linux-2.6/include/linux/uprobes.h"
struct uprobes_state {
};
static inline __attribute__((no_instrument_function)) int
uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer =
*uc)
{
 return -38;
}
static inline __attribute__((no_instrument_function)) int
uprobe_apply(struct inode *inode, loff_t offset, struct uprobe_consumer *uc=
, bool add)
{
 return -38;
}
static inline __attribute__((no_instrument_function)) void
uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume=
r *uc)
{
}
static inline __attribute__((no_instrument_function)) int uprobe_mmap(struc=
t vm_area_struct *vma)
{
 return 0;
}
static inline __attribute__((no_instrument_function)) void
uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon=
g end)
{
}
static inline __attribute__((no_instrument_function)) void uprobe_start_dup=
_mmap(void)
{
}
static inline __attribute__((no_instrument_function)) void uprobe_end_dup_m=
map(void)
{
}
static inline __attribute__((no_instrument_function)) void
uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
{
}
static inline __attribute__((no_instrument_function)) void uprobe_notify_re=
sume(struct pt_regs *regs)
{
}
static inline __attribute__((no_instrument_function)) bool uprobe_deny_sign=
al(void)
{
 return false;
}
static inline __attribute__((no_instrument_function)) unsigned long uprobe_=
get_swbp_addr(struct pt_regs *regs)
{
 return 0;
}
static inline __attribute__((no_instrument_function)) void uprobe_free_utas=
k(struct task_struct *t)
{
}
static inline __attribute__((no_instrument_function)) void uprobe_copy_proc=
ess(struct task_struct *t)
{
}
static inline __attribute__((no_instrument_function)) void uprobe_clear_sta=
te(struct mm_struct *mm)
{
}
# 15 "/usr/src/linux-2.6/include/linux/mm_types.h" 2
# 1 "/usr/src/linux-2.6/include/linux/page-flags-layout.h" 1




# 1 "include/generated/bounds.h" 1
# 6 "/usr/src/linux-2.6/include/linux/page-flags-layout.h" 2
# 16 "/usr/src/linux-2.6/include/linux/mm_types.h" 2

# 1 "/usr/src/linux-2.6/arch/x86/include/asm/mmu.h" 1
# 11 "/usr/src/linux-2.6/arch/x86/include/asm/mmu.h"
typedef struct {
 void *ldt;
 int size;






 struct mutex lock;
 void *vdso;
} mm_context_t;




static inline __attribute__((no_instrument_function)) void leave_mm(int cpu)
{
}
# 18 "/usr/src/linux-2.6/include/linux/mm_types.h" 2






struct address_space;
# 41 "/usr/src/linux-2.6/include/linux/mm_types.h"
struct page {

 unsigned long flags;

 struct address_space *mapping;







 struct {
  union {
   unsigned long index;
   void *freelist;
   bool pfmemalloc;
# 66 "/usr/src/linux-2.6/include/linux/mm_types.h"
  };

  union {



   unsigned long counters;
# 82 "/usr/src/linux-2.6/include/linux/mm_types.h"
   struct {

    union {
# 101 "/usr/src/linux-2.6/include/linux/mm_types.h"
     atomic_t _mapcount;

     struct {
      unsigned inuse:16;
      unsigned objects:15;
      unsigned frozen:1;
     };
     int units;
    };
    atomic_t _count;
   };
  };
 };


 union {
  struct list_head lru;


  struct {
   struct page *next;




   short int pages;
   short int pobjects;

  };

  struct list_head list;
  struct slab *slab_page;
 };


 union {
  unsigned long private;
# 147 "/usr/src/linux-2.6/include/linux/mm_types.h"
  struct kmem_cache *slab_cache;
  struct page *first_page;
 };
# 180 "/usr/src/linux-2.6/include/linux/mm_types.h"
}





 __attribute__((aligned(2 * sizeof(unsigned long))))

;

struct page_frag {
 struct page *page;




 __u16 offset;
 __u16 size;

};

typedef unsigned long vm_flags_t;






struct vm_region {
 struct rb_node vm_rb;
 vm_flags_t vm_flags;
 unsigned long vm_start;
 unsigned long vm_end;
 unsigned long vm_top;
 unsigned long vm_pgoff;
 struct file *vm_file;

 int vm_usage;
 bool vm_icache_flushed : 1;

};







struct vm_area_struct {


 unsigned long vm_start;
 unsigned long vm_end;



 struct vm_area_struct *vm_next, *vm_prev;

 struct rb_node vm_rb;







 unsigned long rb_subtree_gap;



 struct mm_struct *vm_mm;
 pgprot_t vm_page_prot;
 unsigned long vm_flags;






 union {
  struct {
   struct rb_node rb;
   unsigned long rb_subtree_last;
  } linear;
  struct list_head nonlinear;
 } shared;







 struct list_head anon_vma_chain;

 struct anon_vma *anon_vma;


 const struct vm_operations_struct *vm_ops;


 unsigned long vm_pgoff;

 struct file * vm_file;
 void * vm_private_data;







};

struct core_thread {
 struct task_struct *task;
 struct core_thread *next;
};

struct core_state {
 atomic_t nr_threads;
 struct core_thread dumper;
 struct completion startup;
};

enum {
 MM_FILEPAGES,
 MM_ANONPAGES,
 MM_SWAPENTS,
 NR_MM_COUNTERS
};
# 321 "/usr/src/linux-2.6/include/linux/mm_types.h"
struct mm_rss_stat {
 atomic_long_t count[NR_MM_COUNTERS];
};

struct kioctx_table;
struct mm_struct {
 struct vm_area_struct * mmap;
 struct rb_root mm_rb;
 struct vm_area_struct * mmap_cache;

 unsigned long (*get_unmapped_area) (struct file *filp,
    unsigned long addr, unsigned long len,
    unsigned long pgoff, unsigned long flags);

 unsigned long mmap_base;
 unsigned long mmap_legacy_base;
 unsigned long task_size;
 unsigned long highest_vm_end;
 pgd_t * pgd;
 atomic_t mm_users;
 atomic_t mm_count;
 int map_count;

 spinlock_t page_table_lock;
 struct rw_semaphore mmap_sem;

 struct list_head mmlist;





 unsigned long hiwater_rss;
 unsigned long hiwater_vm;

 unsigned long total_vm;
 unsigned long locked_vm;
 unsigned long pinned_vm;
 unsigned long shared_vm;
 unsigned long exec_vm;
 unsigned long stack_vm;
 unsigned long def_flags;
 unsigned long nr_ptes;
 unsigned long start_code, end_code, start_data, end_data;
 unsigned long start_brk, brk, start_stack;
 unsigned long arg_start, arg_end, env_start, env_end;

 unsigned long saved_auxv[(2*(2 + 19 + 1))];





 struct mm_rss_stat rss_stat;

 struct linux_binfmt *binfmt;

 cpumask_var_t cpu_vm_mask_var;


 mm_context_t context;

 unsigned long flags;

 struct core_state *core_state;

 spinlock_t ioctx_lock;
 struct kioctx_table *ioctx_table;
# 405 "/usr/src/linux-2.6/include/linux/mm_types.h"
 struct file *exe_file;
# 438 "/usr/src/linux-2.6/include/linux/mm_types.h"
 struct uprobes_state uprobes_state;
};





static inline __attribute__((no_instrument_function)) void mm_init_cpumask(=
struct mm_struct *mm)
{



}


static inline __attribute__((no_instrument_function)) cpumask_t *mm_cpumask=
(struct mm_struct *mm)
{
 return mm->cpu_vm_mask_var;
}
# 25 "/usr/src/linux-2.6/include/linux/sched.h" 2




# 1 "/usr/src/linux-2.6/arch/x86/include/asm/cputime.h" 1
# 1 "/usr/src/linux-2.6/include/asm-generic/cputime.h" 1







# 1 "/usr/src/linux-2.6/include/asm-generic/cputime_jiffies.h" 1



typedef unsigned long cputime_t;






typedef u64 cputime64_t;
# 9 "/usr/src/linux-2.6/include/asm-generic/cputime.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/asm/cputime.h" 2
# 30 "/usr/src/linux-2.6/include/linux/sched.h" 2

# 1 "/usr/src/linux-2.6/include/linux/smp.h" 1
# 15 "/usr/src/linux-2.6/include/linux/smp.h"
extern void cpu_idle(void);

typedef void (*smp_call_func_t)(void *info);
struct call_single_data {
 struct list_head list;
 smp_call_func_t func;
 void *info;
 u16 flags;
};


extern unsigned int total_cpus;

int smp_call_function_single(int cpuid, smp_call_func_t func, void *info,
        int wait);




int on_each_cpu(smp_call_func_t func, void *info, int wait);





void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
  void *info, bool wait);






void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
  smp_call_func_t func, void *info, bool wait,
  gfp_t gfp_flags);
# 130 "/usr/src/linux-2.6/include/linux/smp.h"
static inline __attribute__((no_instrument_function)) void smp_send_stop(vo=
id) { }





static inline __attribute__((no_instrument_function)) int up_smp_call_funct=
ion(smp_call_func_t func, void *info)
{
 return 0;
}



static inline __attribute__((no_instrument_function)) void smp_send_resched=
ule(int cpu) { }



static inline __attribute__((no_instrument_function)) void call_function_in=
it(void) { }

static inline __attribute__((no_instrument_function)) int
smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
        void *info, int wait)
{
 return smp_call_function_single(0, func, info, wait);
}

static inline __attribute__((no_instrument_function)) void kick_all_cpus_sy=
nc(void) { }

static inline __attribute__((no_instrument_function)) void __smp_call_funct=
ion_single(int cpuid,
  struct call_single_data *data, int wait)
{
 on_each_cpu(data->func, data->info, wait);
}
# 195 "/usr/src/linux-2.6/include/linux/smp.h"
extern void arch_disable_smp_support(void);

void smp_setup_processor_id(void);
# 32 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/sem.h" 1






# 1 "/usr/src/linux-2.6/include/uapi/linux/sem.h" 1



# 1 "/usr/src/linux-2.6/include/linux/ipc.h" 1




# 1 "/usr/src/linux-2.6/include/linux/uidgid.h" 1
# 15 "/usr/src/linux-2.6/include/linux/uidgid.h"
# 1 "/usr/src/linux-2.6/include/linux/highuid.h" 1
# 34 "/usr/src/linux-2.6/include/linux/highuid.h"
extern int overflowuid;
extern int overflowgid;

extern void __bad_uid(void);
extern void __bad_gid(void);
# 81 "/usr/src/linux-2.6/include/linux/highuid.h"
extern int fs_overflowuid;
extern int fs_overflowgid;
# 16 "/usr/src/linux-2.6/include/linux/uidgid.h" 2

struct user_namespace;
extern struct user_namespace init_user_ns;
# 46 "/usr/src/linux-2.6/include/linux/uidgid.h"
typedef uid_t kuid_t;
typedef gid_t kgid_t;

static inline __attribute__((no_instrument_function)) uid_t __kuid_val(kuid=
_t uid)
{
 return uid;
}

static inline __attribute__((no_instrument_function)) gid_t __kgid_val(kgid=
_t gid)
{
 return gid;
}
# 70 "/usr/src/linux-2.6/include/linux/uidgid.h"
static inline __attribute__((no_instrument_function)) bool uid_eq(kuid_t le=
ft, kuid_t right)
{
 return __kuid_val(left) =3D=3D __kuid_val(right);
}

static inline __attribute__((no_instrument_function)) bool gid_eq(kgid_t le=
ft, kgid_t right)
{
 return __kgid_val(left) =3D=3D __kgid_val(right);
}

static inline __attribute__((no_instrument_function)) bool uid_gt(kuid_t le=
ft, kuid_t right)
{
 return __kuid_val(left) > __kuid_val(right);
}

static inline __attribute__((no_instrument_function)) bool gid_gt(kgid_t le=
ft, kgid_t right)
{
 return __kgid_val(left) > __kgid_val(right);
}

static inline __attribute__((no_instrument_function)) bool uid_gte(kuid_t l=
eft, kuid_t right)
{
 return __kuid_val(left) >=3D __kuid_val(right);
}

static inline __attribute__((no_instrument_function)) bool gid_gte(kgid_t l=
eft, kgid_t right)
{
 return __kgid_val(left) >=3D __kgid_val(right);
}

static inline __attribute__((no_instrument_function)) bool uid_lt(kuid_t le=
ft, kuid_t right)
{
 return __kuid_val(left) < __kuid_val(right);
}

static inline __attribute__((no_instrument_function)) bool gid_lt(kgid_t le=
ft, kgid_t right)
{
 return __kgid_val(left) < __kgid_val(right);
}

static inline __attribute__((no_instrument_function)) bool uid_lte(kuid_t l=
eft, kuid_t right)
{
 return __kuid_val(left) <=3D __kuid_val(right);
}

static inline __attribute__((no_instrument_function)) bool gid_lte(kgid_t l=
eft, kgid_t right)
{
 return __kgid_val(left) <=3D __kgid_val(right);
}

static inline __attribute__((no_instrument_function)) bool uid_valid(kuid_t=
 uid)
{
 return !uid_eq(uid, ((kuid_t) -1 ));
}

static inline __attribute__((no_instrument_function)) bool gid_valid(kgid_t=
 gid)
{
 return !gid_eq(gid, ((kgid_t) -1 ));
}
# 152 "/usr/src/linux-2.6/include/linux/uidgid.h"
static inline __attribute__((no_instrument_function)) kuid_t make_kuid(stru=
ct user_namespace *from, uid_t uid)
{
 return ((kuid_t) uid );
}

static inline __attribute__((no_instrument_function)) kgid_t make_kgid(stru=
ct user_namespace *from, gid_t gid)
{
 return ((kgid_t) gid );
}

static inline __attribute__((no_instrument_function)) uid_t from_kuid(struc=
t user_namespace *to, kuid_t kuid)
{
 return __kuid_val(kuid);
}

static inline __attribute__((no_instrument_function)) gid_t from_kgid(struc=
t user_namespace *to, kgid_t kgid)
{
 return __kgid_val(kgid);
}

static inline __attribute__((no_instrument_function)) uid_t from_kuid_munge=
d(struct user_namespace *to, kuid_t kuid)
{
 uid_t uid =3D from_kuid(to, kuid);
 if (uid =3D=3D (uid_t)-1)
  uid =3D overflowuid;
 return uid;
}

static inline __attribute__((no_instrument_function)) gid_t from_kgid_munge=
d(struct user_namespace *to, kgid_t kgid)
{
 gid_t gid =3D from_kgid(to, kgid);
 if (gid =3D=3D (gid_t)-1)
  gid =3D overflowgid;
 return gid;
}

static inline __attribute__((no_instrument_function)) bool kuid_has_mapping=
(struct user_namespace *ns, kuid_t uid)
{
 return true;
}

static inline __attribute__((no_instrument_function)) bool kgid_has_mapping=
(struct user_namespace *ns, kgid_t gid)
{
 return true;
}
# 6 "/usr/src/linux-2.6/include/linux/ipc.h" 2
# 1 "/usr/src/linux-2.6/include/uapi/linux/ipc.h" 1
# 9 "/usr/src/linux-2.6/include/uapi/linux/ipc.h"
struct ipc_perm
{
 __kernel_key_t key;
 __kernel_uid_t uid;
 __kernel_gid_t gid;
 __kernel_uid_t cuid;
 __kernel_gid_t cgid;
 __kernel_mode_t mode;
 unsigned short seq;
};


# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/ipcbuf.h" 1
# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/ipcbuf.h" 1
# 19 "/usr/src/linux-2.6/include/uapi/asm-generic/ipcbuf.h"
struct ipc64_perm {
 __kernel_key_t key;
 __kernel_uid32_t uid;
 __kernel_gid32_t gid;
 __kernel_uid32_t cuid;
 __kernel_gid32_t cgid;
 __kernel_mode_t mode;

 unsigned char __pad1[4 - sizeof(__kernel_mode_t)];
 unsigned short seq;
 unsigned short __pad2;
 unsigned long __unused1;
 unsigned long __unused2;
};
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/ipcbuf.h" 2
# 22 "/usr/src/linux-2.6/include/uapi/linux/ipc.h" 2
# 57 "/usr/src/linux-2.6/include/uapi/linux/ipc.h"
struct ipc_kludge {
 struct msgbuf *msgp;
 long msgtyp;
};
# 7 "/usr/src/linux-2.6/include/linux/ipc.h" 2




struct kern_ipc_perm
{
 spinlock_t lock;
 int deleted;
 int id;
 key_t key;
 kuid_t uid;
 kgid_t gid;
 kuid_t cuid;
 kgid_t cgid;
 umode_t mode;
 unsigned long seq;
 void *security;
};
# 5 "/usr/src/linux-2.6/include/uapi/linux/sem.h" 2
# 23 "/usr/src/linux-2.6/include/uapi/linux/sem.h"
struct semid_ds {
 struct ipc_perm sem_perm;
 __kernel_time_t sem_otime;
 __kernel_time_t sem_ctime;
 struct sem *sem_base;
 struct sem_queue *sem_pending;
 struct sem_queue **sem_pending_last;
 struct sem_undo *undo;
 unsigned short sem_nsems;
};


# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/sembuf.h" 1
# 13 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/sembuf.h"
struct semid64_ds {
 struct ipc64_perm sem_perm;
 __kernel_time_t sem_otime;
 unsigned long __unused1;
 __kernel_time_t sem_ctime;
 unsigned long __unused2;
 unsigned long sem_nsems;
 unsigned long __unused3;
 unsigned long __unused4;
};
# 36 "/usr/src/linux-2.6/include/uapi/linux/sem.h" 2


struct sembuf {
 unsigned short sem_num;
 short sem_op;
 short sem_flg;
};


union semun {
 int val;
 struct semid_ds *buf;
 unsigned short *array;
 struct seminfo *__buf;
 void *__pad;
};

struct seminfo {
 int semmap;
 int semmni;
 int semmns;
 int semmnu;
 int semmsl;
 int semopm;
 int semume;
 int semusz;
 int semvmx;
 int semaem;
};
# 8 "/usr/src/linux-2.6/include/linux/sem.h" 2

struct task_struct;


struct sem_array {
 struct kern_ipc_perm
    sem_perm;
 time_t sem_ctime;
 struct sem *sem_base;
 struct list_head pending_alter;

 struct list_head pending_const;

 struct list_head list_id;
 int sem_nsems;
 int complex_count;
};



struct sysv_sem {
 struct sem_undo_list *undo_list;
};

extern int copy_semundo(unsigned long clone_flags, struct task_struct *tsk);
extern void exit_sem(struct task_struct *tsk);
# 33 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/signal.h" 1




# 1 "/usr/src/linux-2.6/include/uapi/linux/signal.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/asm/signal.h" 1
# 20 "/usr/src/linux-2.6/arch/x86/include/asm/signal.h"
typedef unsigned long old_sigset_t;

typedef struct {
 unsigned long sig[(64 / 32)];
} sigset_t;


typedef sigset_t compat_sigset_t;



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/signal.h" 1
# 10 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/signal.h"
struct siginfo;
# 93 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/signal.h"
# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/signal-defs.h" 1
# 17 "/usr/src/linux-2.6/include/uapi/asm-generic/signal-defs.h"
typedef void __signalfn_t(int);
typedef __signalfn_t *__sighandler_t;

typedef void __restorefn_t(void);
typedef __restorefn_t *__sigrestore_t;
# 94 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/signal.h" 2
# 127 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/signal.h"
typedef struct sigaltstack {
 void *ss_sp;
 int ss_flags;
 size_t ss_size;
} stack_t;
# 32 "/usr/src/linux-2.6/arch/x86/include/asm/signal.h" 2

extern void do_notify_resume(struct pt_regs *, void *, __u32);
# 48 "/usr/src/linux-2.6/arch/x86/include/asm/signal.h"
static inline __attribute__((no_instrument_function)) void __gen_sigaddset(=
sigset_t *set, int _sig)
{
 asm("btsl %1,%0" : "+m"(*set) : "Ir"(_sig - 1) : "cc");
}

static inline __attribute__((no_instrument_function)) void __const_sigaddse=
t(sigset_t *set, int _sig)
{
 unsigned long sig =3D _sig - 1;
 set->sig[sig / 32] |=3D 1 << (sig % 32);
}







static inline __attribute__((no_instrument_function)) void __gen_sigdelset(=
sigset_t *set, int _sig)
{
 asm("btrl %1,%0" : "+m"(*set) : "Ir"(_sig - 1) : "cc");
}

static inline __attribute__((no_instrument_function)) void __const_sigdelse=
t(sigset_t *set, int _sig)
{
 unsigned long sig =3D _sig - 1;
 set->sig[sig / 32] &=3D ~(1 << (sig % 32));
}

static inline __attribute__((no_instrument_function)) int __const_sigismemb=
er(sigset_t *set, int _sig)
{
 unsigned long sig =3D _sig - 1;
 return 1 & (set->sig[sig / 32] >> (sig % 32));
}

static inline __attribute__((no_instrument_function)) int __gen_sigismember=
(sigset_t *set, int _sig)
{
 int ret;
 asm("btl %2,%1\n\tsbbl %0,%0"
     : "=3Dr"(ret) : "m"(*set), "Ir"(_sig-1) : "cc");
 return ret;
}






static inline __attribute__((no_instrument_function)) int sigfindinword(uns=
igned long word)
{
 asm("bsfl %1,%0" : "=3Dr"(word) : "rm"(word) : "cc");
 return word;
}

struct pt_regs;
# 5 "/usr/src/linux-2.6/include/uapi/linux/signal.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/siginfo.h" 1
# 14 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/siginfo.h"
# 1 "/usr/src/linux-2.6/include/asm-generic/siginfo.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/siginfo.h" 1






typedef union sigval {
 int sival_int;
 void *sival_ptr;
} sigval_t;
# 48 "/usr/src/linux-2.6/include/uapi/asm-generic/siginfo.h"
typedef struct siginfo {
 int si_signo;
 int si_errno;
 int si_code;

 union {
  int _pad[((128 - (3 * sizeof(int))) / sizeof(int))];


  struct {
   __kernel_pid_t _pid;
   __kernel_uid32_t _uid;
  } _kill;


  struct {
   __kernel_timer_t _tid;
   int _overrun;
   char _pad[sizeof( __kernel_uid32_t) - sizeof(int)];
   sigval_t _sigval;
   int _sys_private;
  } _timer;


  struct {
   __kernel_pid_t _pid;
   __kernel_uid32_t _uid;
   sigval_t _sigval;
  } _rt;


  struct {
   __kernel_pid_t _pid;
   __kernel_uid32_t _uid;
   int _status;
   __kernel_clock_t _utime;
   __kernel_clock_t _stime;
  } _sigchld;


  struct {
   void *_addr;



   short _addr_lsb;
  } _sigfault;


  struct {
   long _band;
   int _fd;
  } _sigpoll;


  struct {
   void *_call_addr;
   int _syscall;
   unsigned int _arch;
  } _sigsys;
 } _sifields;
} siginfo_t;
# 278 "/usr/src/linux-2.6/include/uapi/asm-generic/siginfo.h"
typedef struct sigevent {
 sigval_t sigev_value;
 int sigev_signo;
 int sigev_notify;
 union {
  int _pad[((64 - (sizeof(int) * 2 + sizeof(sigval_t))) / sizeof(int))];
   int _tid;

  struct {
   void (*_function)(sigval_t);
   void *_attribute;
  } _sigev_thread;
 } _sigev_un;
} sigevent_t;
# 5 "/usr/src/linux-2.6/include/asm-generic/siginfo.h" 2
# 17 "/usr/src/linux-2.6/include/asm-generic/siginfo.h"
struct siginfo;
void do_schedule_next_timer(struct siginfo *info);





static inline __attribute__((no_instrument_function)) void copy_siginfo(str=
uct siginfo *to, struct siginfo *from)
{
 if (from->si_code < 0)
  __builtin_memcpy(to, from, sizeof(*to));
 else

  __builtin_memcpy(to, from, (3 * sizeof(int)) + sizeof(from->_sifields._si=
gchld));
}



extern int copy_siginfo_to_user(struct siginfo *to, struct siginfo *from);
# 15 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/siginfo.h" 2
# 6 "/usr/src/linux-2.6/include/uapi/linux/signal.h" 2
# 6 "/usr/src/linux-2.6/include/linux/signal.h" 2

struct task_struct;


extern int print_fatal_signals;




struct sigqueue {
 struct list_head list;
 int flags;
 siginfo_t info;
 struct user_struct *user;
};




struct sigpending {
 struct list_head list;
 sigset_t signal;
};
# 73 "/usr/src/linux-2.6/include/linux/signal.h"
static inline __attribute__((no_instrument_function)) int sigisemptyset(sig=
set_t *set)
{
 extern void _NSIG_WORDS_is_unsupported_size(void);
 switch ((64 / 32)) {
 case 4:
  return (set->sig[3] | set->sig[2] |
   set->sig[1] | set->sig[0]) =3D=3D 0;
 case 2:
  return (set->sig[1] | set->sig[0]) =3D=3D 0;
 case 1:
  return set->sig[0] =3D=3D 0;
 default:
  _NSIG_WORDS_is_unsupported_size();
  return 0;
 }
}
# 120 "/usr/src/linux-2.6/include/linux/signal.h"
static inline __attribute__((no_instrument_function)) void sigorsets(sigset=
_t *r, const sigset_t *a, const sigset_t *b) { extern void _NSIG_WORDS_is_u=
nsupported_size(void); unsigned long a0, a1, a2, a3, b0, b1, b2, b3; switch=
 ((64 / 32)) { case 4: a3 =3D a->sig[3]; a2 =3D a->sig[2]; b3 =3D b->sig[3]=
; b2 =3D b->sig[2]; r->sig[3] =3D ((a3) | (b3)); r->sig[2] =3D ((a2) | (b2)=
); case 2: a1 =3D a->sig[1]; b1 =3D b->sig[1]; r->sig[1] =3D ((a1) | (b1));=
 case 1: a0 =3D a->sig[0]; b0 =3D b->sig[0]; r->sig[0] =3D ((a0) | (b0)); b=
reak; default: _NSIG_WORDS_is_unsupported_size(); } }


static inline __attribute__((no_instrument_function)) void sigandsets(sigse=
t_t *r, const sigset_t *a, const sigset_t *b) { extern void _NSIG_WORDS_is_=
unsupported_size(void); unsigned long a0, a1, a2, a3, b0, b1, b2, b3; switc=
h ((64 / 32)) { case 4: a3 =3D a->sig[3]; a2 =3D a->sig[2]; b3 =3D b->sig[3=
]; b2 =3D b->sig[2]; r->sig[3] =3D ((a3) & (b3)); r->sig[2] =3D ((a2) & (b2=
)); case 2: a1 =3D a->sig[1]; b1 =3D b->sig[1]; r->sig[1] =3D ((a1) & (b1))=
; case 1: a0 =3D a->sig[0]; b0 =3D b->sig[0]; r->sig[0] =3D ((a0) & (b0)); =
break; default: _NSIG_WORDS_is_unsupported_size(); } }


static inline __attribute__((no_instrument_function)) void sigandnsets(sigs=
et_t *r, const sigset_t *a, const sigset_t *b) { extern void _NSIG_WORDS_is=
_unsupported_size(void); unsigned long a0, a1, a2, a3, b0, b1, b2, b3; swit=
ch ((64 / 32)) { case 4: a3 =3D a->sig[3]; a2 =3D a->sig[2]; b3 =3D b->sig[=
3]; b2 =3D b->sig[2]; r->sig[3] =3D ((a3) & ~(b3)); r->sig[2] =3D ((a2) & ~=
(b2)); case 2: a1 =3D a->sig[1]; b1 =3D b->sig[1]; r->sig[1] =3D ((a1) & ~(=
b1)); case 1: a0 =3D a->sig[0]; b0 =3D b->sig[0]; r->sig[0] =3D ((a0) & ~(b=
0)); break; default: _NSIG_WORDS_is_unsupported_size(); } }
# 150 "/usr/src/linux-2.6/include/linux/signal.h"
static inline __attribute__((no_instrument_function)) void signotset(sigset=
_t *set) { extern void _NSIG_WORDS_is_unsupported_size(void); switch ((64 /=
 32)) { case 4: set->sig[3] =3D (~(set->sig[3])); set->sig[2] =3D (~(set->s=
ig[2])); case 2: set->sig[1] =3D (~(set->sig[1])); case 1: set->sig[0] =3D =
(~(set->sig[0])); break; default: _NSIG_WORDS_is_unsupported_size(); } }




static inline __attribute__((no_instrument_function)) void sigemptyset(sigs=
et_t *set)
{
 switch ((64 / 32)) {
 default:
  __builtin_memset(set, 0, sizeof(sigset_t));
  break;
 case 2: set->sig[1] =3D 0;
 case 1: set->sig[0] =3D 0;
  break;
 }
}

static inline __attribute__((no_instrument_function)) void sigfillset(sigse=
t_t *set)
{
 switch ((64 / 32)) {
 default:
  __builtin_memset(set, -1, sizeof(sigset_t));
  break;
 case 2: set->sig[1] =3D -1;
 case 1: set->sig[0] =3D -1;
  break;
 }
}



static inline __attribute__((no_instrument_function)) void sigaddsetmask(si=
gset_t *set, unsigned long mask)
{
 set->sig[0] |=3D mask;
}

static inline __attribute__((no_instrument_function)) void sigdelsetmask(si=
gset_t *set, unsigned long mask)
{
 set->sig[0] &=3D ~mask;
}

static inline __attribute__((no_instrument_function)) int sigtestsetmask(si=
gset_t *set, unsigned long mask)
{
 return (set->sig[0] & mask) !=3D 0;
}

static inline __attribute__((no_instrument_function)) void siginitset(sigse=
t_t *set, unsigned long mask)
{
 set->sig[0] =3D mask;
 switch ((64 / 32)) {
 default:
  __builtin_memset(&set->sig[1], 0, sizeof(long)*((64 / 32)-1));
  break;
 case 2: set->sig[1] =3D 0;
 case 1: ;
 }
}

static inline __attribute__((no_instrument_function)) void siginitsetinv(si=
gset_t *set, unsigned long mask)
{
 set->sig[0] =3D ~mask;
 switch ((64 / 32)) {
 default:
  __builtin_memset(&set->sig[1], -1, sizeof(long)*((64 / 32)-1));
  break;
 case 2: set->sig[1] =3D -1;
 case 1: ;
 }
}



static inline __attribute__((no_instrument_function)) void init_sigpending(=
struct sigpending *sig)
{
 sigemptyset(&sig->signal);
 INIT_LIST_HEAD(&sig->list);
}

extern void flush_sigqueue(struct sigpending *queue);


static inline __attribute__((no_instrument_function)) int valid_signal(unsi=
gned long sig)
{
 return sig <=3D 64 ? 1 : 0;
}

struct timespec;
struct pt_regs;

extern int next_signal(struct sigpending *pending, sigset_t *mask);
extern int do_send_sig_info(int sig, struct siginfo *info,
    struct task_struct *p, bool group);
extern int group_send_sig_info(int sig, struct siginfo *info, struct task_s=
truct *p);
extern int __group_send_sig_info(int, struct siginfo *, struct task_struct =
*);
extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
    const struct timespec *);
extern int sigprocmask(int, sigset_t *, sigset_t *);
extern void set_current_blocked(sigset_t *);
extern void __set_current_blocked(const sigset_t *);
extern int show_unhandled_signals;
extern int sigsuspend(sigset_t *);

struct sigaction {

 __sighandler_t sa_handler;
 unsigned long sa_flags;





 __sigrestore_t sa_restorer;

 sigset_t sa_mask;
};

struct k_sigaction {
 struct sigaction sa;



};


struct old_sigaction {
 __sighandler_t sa_handler;
 old_sigset_t sa_mask;
 unsigned long sa_flags;
 __sigrestore_t sa_restorer;
};


struct ksignal {
 struct k_sigaction ka;
 siginfo_t info;
 int sig;
};

extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *retur=
n_ka, struct pt_regs *regs, void *cookie);
extern void signal_setup_done(int failed, struct ksignal *ksig, int steppin=
g);
extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *=
ka, struct pt_regs *regs, int stepping);
extern void exit_signals(struct task_struct *tsk);
# 305 "/usr/src/linux-2.6/include/linux/signal.h"
extern struct kmem_cache *sighand_cachep;

int unhandled_signal(struct task_struct *tsk, int sig);
# 432 "/usr/src/linux-2.6/include/linux/signal.h"
void signals_init(void);

int restore_altstack(const stack_t *);
int __save_altstack(stack_t *, unsigned long);
# 446 "/usr/src/linux-2.6/include/linux/signal.h"
struct seq_file;
extern void render_sigset_t(struct seq_file *, const char *, sigset_t *);
# 34 "/usr/src/linux-2.6/include/linux/sched.h" 2


# 1 "/usr/src/linux-2.6/include/linux/pid.h" 1





enum pid_type
{
 PIDTYPE_PID,
 PIDTYPE_PGID,
 PIDTYPE_SID,
 PIDTYPE_MAX
};
# 50 "/usr/src/linux-2.6/include/linux/pid.h"
struct upid {

 int nr;
 struct pid_namespace *ns;
 struct hlist_node pid_chain;
};

struct pid
{
 atomic_t count;
 unsigned int level;

 struct hlist_head tasks[PIDTYPE_MAX];
 struct callback_head rcu;
 struct upid numbers[1];
};

extern struct pid init_struct_pid;

struct pid_link
{
 struct hlist_node node;
 struct pid *pid;
};

static inline __attribute__((no_instrument_function)) struct pid *get_pid(s=
truct pid *pid)
{
 if (pid)
  atomic_inc(&pid->count);
 return pid;
}

extern void put_pid(struct pid *pid);
extern struct task_struct *pid_task(struct pid *pid, enum pid_type);
extern struct task_struct *get_pid_task(struct pid *pid, enum pid_type);

extern struct pid *get_task_pid(struct task_struct *task, enum pid_type typ=
e);




extern void attach_pid(struct task_struct *task, enum pid_type);
extern void detach_pid(struct task_struct *task, enum pid_type);
extern void change_pid(struct task_struct *task, enum pid_type,
   struct pid *pid);
extern void transfer_pid(struct task_struct *old, struct task_struct *new,
    enum pid_type);

struct pid_namespace;
extern struct pid_namespace init_pid_ns;
# 110 "/usr/src/linux-2.6/include/linux/pid.h"
extern struct pid *find_pid_ns(int nr, struct pid_namespace *ns);
extern struct pid *find_vpid(int nr);




extern struct pid *find_get_pid(int nr);
extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);

extern struct pid *alloc_pid(struct pid_namespace *ns);
extern void free_pid(struct pid *pid);
extern void disable_pid_allocation(struct pid_namespace *ns);
# 134 "/usr/src/linux-2.6/include/linux/pid.h"
static inline __attribute__((no_instrument_function)) struct pid_namespace =
*ns_of_pid(struct pid *pid)
{
 struct pid_namespace *ns =3D ((void *)0);
 if (pid)
  ns =3D pid->numbers[pid->level].ns;
 return ns;
}







static inline __attribute__((no_instrument_function)) bool is_child_reaper(=
struct pid *pid)
{
 return pid->numbers[pid->level].nr =3D=3D 1;
}
# 164 "/usr/src/linux-2.6/include/linux/pid.h"
static inline __attribute__((no_instrument_function)) pid_t pid_nr(struct p=
id *pid)
{
 pid_t nr =3D 0;
 if (pid)
  nr =3D pid->numbers[0].nr;
 return nr;
}

pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
pid_t pid_vnr(struct pid *pid);
# 37 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/percpu.h" 1






# 1 "/usr/src/linux-2.6/include/linux/pfn.h" 1
# 8 "/usr/src/linux-2.6/include/linux/percpu.h" 2
# 81 "/usr/src/linux-2.6/include/linux/percpu.h"
extern void *pcpu_base_addr;
extern const unsigned long *pcpu_unit_offsets;

struct pcpu_group_info {
 int nr_units;
 unsigned long base_offset;
 unsigned int *cpu_map;

};

struct pcpu_alloc_info {
 size_t static_size;
 size_t reserved_size;
 size_t dyn_size;
 size_t unit_size;
 size_t atom_size;
 size_t alloc_size;
 size_t __ai_size;
 int nr_groups;
 struct pcpu_group_info groups[];
};

enum pcpu_fc {
 PCPU_FC_AUTO,
 PCPU_FC_EMBED,
 PCPU_FC_PAGE,

 PCPU_FC_NR,
};
extern const char * const pcpu_fc_names[PCPU_FC_NR];

extern enum pcpu_fc pcpu_chosen_fc;

typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size,
         size_t align);
typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
typedef int (pcpu_fc_cpu_distance_fn_t)(unsigned int from, unsigned int to);

extern struct pcpu_alloc_info * __attribute__ ((__section__(".init.text")))=
 __attribute__((__cold__)) __attribute__((no_instrument_function)) pcpu_all=
oc_alloc_info(int nr_groups,
            int nr_units);
extern void __attribute__ ((__section__(".init.text"))) __attribute__((__co=
ld__)) __attribute__((no_instrument_function)) pcpu_free_alloc_info(struct =
pcpu_alloc_info *ai);

extern int __attribute__ ((__section__(".init.text"))) __attribute__((__col=
d__)) __attribute__((no_instrument_function)) pcpu_setup_first_chunk(const =
struct pcpu_alloc_info *ai,
      void *base_addr);


extern int __attribute__ ((__section__(".init.text"))) __attribute__((__col=
d__)) __attribute__((no_instrument_function)) pcpu_embed_first_chunk(size_t=
 reserved_size, size_t dyn_size,
    size_t atom_size,
    pcpu_fc_cpu_distance_fn_t cpu_distance_fn,
    pcpu_fc_alloc_fn_t alloc_fn,
    pcpu_fc_free_fn_t free_fn);



extern int __attribute__ ((__section__(".init.text"))) __attribute__((__col=
d__)) __attribute__((no_instrument_function)) pcpu_page_first_chunk(size_t =
reserved_size,
    pcpu_fc_alloc_fn_t alloc_fn,
    pcpu_fc_free_fn_t free_fn,
    pcpu_fc_populate_pte_fn_t populate_pte_fn);
# 153 "/usr/src/linux-2.6/include/linux/percpu.h"
extern void *__alloc_reserved_percpu(size_t size, size_t align);
extern bool is_kernel_percpu_address(unsigned long addr);


extern void __attribute__ ((__section__(".init.text"))) __attribute__((__co=
ld__)) __attribute__((no_instrument_function)) setup_per_cpu_areas(void);

extern void __attribute__ ((__section__(".init.text"))) __attribute__((__co=
ld__)) __attribute__((no_instrument_function)) percpu_init_late(void);

extern void *__alloc_percpu(size_t size, size_t align);
extern void free_percpu(void *__pdata);
extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
# 173 "/usr/src/linux-2.6/include/linux/percpu.h"
extern void __bad_size_call_parameter(void);
# 38 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/topology.h" 1
# 32 "/usr/src/linux-2.6/include/linux/topology.h"
# 1 "/usr/src/linux-2.6/include/linux/mmzone.h" 1
# 17 "/usr/src/linux-2.6/include/linux/mmzone.h"
# 1 "/usr/src/linux-2.6/include/linux/pageblock-flags.h" 1
# 29 "/usr/src/linux-2.6/include/linux/pageblock-flags.h"
enum pageblock_bits {
 PB_migrate,
 PB_migrate_end =3D PB_migrate + 3 - 1,


 PB_migrate_skip,

 NR_PAGEBLOCK_BITS
};
# 63 "/usr/src/linux-2.6/include/linux/pageblock-flags.h"
struct page;


unsigned long get_pageblock_flags_group(struct page *page,
     int start_bitidx, int end_bitidx);
void set_pageblock_flags_group(struct page *page, unsigned long flags,
     int start_bitidx, int end_bitidx);
# 18 "/usr/src/linux-2.6/include/linux/mmzone.h" 2
# 38 "/usr/src/linux-2.6/include/linux/mmzone.h"
enum {
 MIGRATE_UNMOVABLE,
 MIGRATE_RECLAIMABLE,
 MIGRATE_MOVABLE,
 MIGRATE_PCPTYPES,
 MIGRATE_RESERVE =3D MIGRATE_PCPTYPES,
# 63 "/usr/src/linux-2.6/include/linux/mmzone.h"
 MIGRATE_TYPES
};
# 76 "/usr/src/linux-2.6/include/linux/mmzone.h"
extern int page_group_by_mobility_disabled;

static inline __attribute__((no_instrument_function)) int get_pageblock_mig=
ratetype(struct page *page)
{
 return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
}

struct free_area {
 struct list_head free_list[MIGRATE_TYPES];
 unsigned long nr_free;
};

struct pglist_data;
# 105 "/usr/src/linux-2.6/include/linux/mmzone.h"
enum zone_stat_item {

 NR_FREE_PAGES,
 NR_ALLOC_BATCH,
 NR_LRU_BASE,
 NR_INACTIVE_ANON =3D NR_LRU_BASE,
 NR_ACTIVE_ANON,
 NR_INACTIVE_FILE,
 NR_ACTIVE_FILE,
 NR_UNEVICTABLE,
 NR_MLOCK,
 NR_ANON_PAGES,
 NR_FILE_MAPPED,

 NR_FILE_PAGES,
 NR_FILE_DIRTY,
 NR_WRITEBACK,
 NR_SLAB_RECLAIMABLE,
 NR_SLAB_UNRECLAIMABLE,
 NR_PAGETABLE,
 NR_KERNEL_STACK,

 NR_UNSTABLE_NFS,
 NR_BOUNCE,
 NR_VMSCAN_WRITE,
 NR_VMSCAN_IMMEDIATE,
 NR_WRITEBACK_TEMP,
 NR_ISOLATED_ANON,
 NR_ISOLATED_FILE,
 NR_SHMEM,
 NR_DIRTIED,
 NR_WRITTEN,
# 145 "/usr/src/linux-2.6/include/linux/mmzone.h"
 NR_ANON_TRANSPARENT_HUGEPAGES,
 NR_FREE_CMA_PAGES,
 NR_VM_ZONE_STAT_ITEMS };
# 162 "/usr/src/linux-2.6/include/linux/mmzone.h"
enum lru_list {
 LRU_INACTIVE_ANON =3D 0,
 LRU_ACTIVE_ANON =3D 0 + 1,
 LRU_INACTIVE_FILE =3D 0 + 2,
 LRU_ACTIVE_FILE =3D 0 + 2 + 1,
 LRU_UNEVICTABLE,
 NR_LRU_LISTS
};





static inline __attribute__((no_instrument_function)) int is_file_lru(enum =
lru_list lru)
{
 return (lru =3D=3D LRU_INACTIVE_FILE || lru =3D=3D LRU_ACTIVE_FILE);
}

static inline __attribute__((no_instrument_function)) int is_active_lru(enu=
m lru_list lru)
{
 return (lru =3D=3D LRU_ACTIVE_ANON || lru =3D=3D LRU_ACTIVE_FILE);
}

static inline __attribute__((no_instrument_function)) int is_unevictable_lr=
u(enum lru_list lru)
{
 return (lru =3D=3D LRU_UNEVICTABLE);
}

struct zone_reclaim_stat {
# 199 "/usr/src/linux-2.6/include/linux/mmzone.h"
 unsigned long recent_rotated[2];
 unsigned long recent_scanned[2];
};

struct lruvec {
 struct list_head lists[NR_LRU_LISTS];
 struct zone_reclaim_stat reclaim_stat;



};
# 226 "/usr/src/linux-2.6/include/linux/mmzone.h"
typedef unsigned isolate_mode_t;

enum zone_watermarks {
 WMARK_MIN,
 WMARK_LOW,
 WMARK_HIGH,
 NR_WMARK
};





struct per_cpu_pages {
 int count;
 int high;
 int batch;


 struct list_head lists[MIGRATE_PCPTYPES];
};

struct per_cpu_pageset {
 struct per_cpu_pages pcp;







};



enum zone_type {
# 281 "/usr/src/linux-2.6/include/linux/mmzone.h"
 ZONE_DMA,
# 296 "/usr/src/linux-2.6/include/linux/mmzone.h"
 ZONE_NORMAL,
# 306 "/usr/src/linux-2.6/include/linux/mmzone.h"
 ZONE_HIGHMEM,

 ZONE_MOVABLE,
 __MAX_NR_ZONES
};



struct zone {



 unsigned long watermark[NR_WMARK];






 unsigned long percpu_drift_mark;
# 335 "/usr/src/linux-2.6/include/linux/mmzone.h"
 unsigned long lowmem_reserve[4];





 unsigned long dirty_balance_reserve;
# 351 "/usr/src/linux-2.6/include/linux/mmzone.h"
 struct per_cpu_pageset *pageset;



 spinlock_t lock;


 bool compact_blockskip_flush;


 unsigned long compact_cached_free_pfn;
 unsigned long compact_cached_migrate_pfn;





 struct free_area free_area[11];






 unsigned long *pageblock_flags;
# 384 "/usr/src/linux-2.6/include/linux/mmzone.h"
 unsigned int compact_considered;
 unsigned int compact_defer_shift;
 int compact_order_failed;





 spinlock_t lru_lock;
 struct lruvec lruvec;

 unsigned long pages_scanned;
 unsigned long flags;


 atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS];





 unsigned int inactive_ratio;



# 435 "/usr/src/linux-2.6/include/linux/mmzone.h"
 wait_queue_head_t * wait_table;
 unsigned long wait_table_hash_nr_entries;
 unsigned long wait_table_bits;




 struct pglist_data *zone_pgdat;

 unsigned long zone_start_pfn;
# 488 "/usr/src/linux-2.6/include/linux/mmzone.h"
 unsigned long spanned_pages;
 unsigned long present_pages;
 unsigned long managed_pages;




 const char *name;
} ;

typedef enum {
 ZONE_RECLAIM_LOCKED,
 ZONE_OOM_LOCKED,
 ZONE_CONGESTED,


 ZONE_TAIL_LRU_DIRTY,



 ZONE_WRITEBACK,


} zone_flags_t;

static inline __attribute__((no_instrument_function)) void zone_set_flag(st=
ruct zone *zone, zone_flags_t flag)
{
 set_bit(flag, &zone->flags);
}

static inline __attribute__((no_instrument_function)) int zone_test_and_set=
_flag(struct zone *zone, zone_flags_t flag)
{
 return test_and_set_bit(flag, &zone->flags);
}

static inline __attribute__((no_instrument_function)) void zone_clear_flag(=
struct zone *zone, zone_flags_t flag)
{
 clear_bit(flag, &zone->flags);
}

static inline __attribute__((no_instrument_function)) int zone_is_reclaim_c=
ongested(const struct zone *zone)
{
 return (__builtin_constant_p((ZONE_CONGESTED)) ? constant_test_bit((ZONE_C=
ONGESTED), (&zone->flags)) : variable_test_bit((ZONE_CONGESTED), (&zone->fl=
ags)));
}

static inline __attribute__((no_instrument_function)) int zone_is_reclaim_d=
irty(const struct zone *zone)
{
 return (__builtin_constant_p((ZONE_TAIL_LRU_DIRTY)) ? constant_test_bit((Z=
ONE_TAIL_LRU_DIRTY), (&zone->flags)) : variable_test_bit((ZONE_TAIL_LRU_DIR=
TY), (&zone->flags)));
}

static inline __attribute__((no_instrument_function)) int zone_is_reclaim_w=
riteback(const struct zone *zone)
{
 return (__builtin_constant_p((ZONE_WRITEBACK)) ? constant_test_bit((ZONE_W=
RITEBACK), (&zone->flags)) : variable_test_bit((ZONE_WRITEBACK), (&zone->fl=
ags)));
}

static inline __attribute__((no_instrument_function)) int zone_is_reclaim_l=
ocked(const struct zone *zone)
{
 return (__builtin_constant_p((ZONE_RECLAIM_LOCKED)) ? constant_test_bit((Z=
ONE_RECLAIM_LOCKED), (&zone->flags)) : variable_test_bit((ZONE_RECLAIM_LOCK=
ED), (&zone->flags)));
}

static inline __attribute__((no_instrument_function)) int zone_is_oom_locke=
d(const struct zone *zone)
{
 return (__builtin_constant_p((ZONE_OOM_LOCKED)) ? constant_test_bit((ZONE_=
OOM_LOCKED), (&zone->flags)) : variable_test_bit((ZONE_OOM_LOCKED), (&zone-=
>flags)));
}

static inline __attribute__((no_instrument_function)) unsigned long zone_en=
d_pfn(const struct zone *zone)
{
 return zone->zone_start_pfn + zone->spanned_pages;
}

static inline __attribute__((no_instrument_function)) bool zone_spans_pfn(c=
onst struct zone *zone, unsigned long pfn)
{
 return zone->zone_start_pfn <=3D pfn && pfn < zone_end_pfn(zone);
}

static inline __attribute__((no_instrument_function)) bool zone_is_initiali=
zed(struct zone *zone)
{
 return !!zone->wait_table;
}

static inline __attribute__((no_instrument_function)) bool zone_is_empty(st=
ruct zone *zone)
{
 return zone->spanned_pages =3D=3D 0;
}
# 661 "/usr/src/linux-2.6/include/linux/mmzone.h"
struct zonelist_cache;






struct zoneref {
 struct zone *zone;
 int zone_idx;
};
# 690 "/usr/src/linux-2.6/include/linux/mmzone.h"
struct zonelist {
 struct zonelist_cache *zlcache_ptr;
 struct zoneref _zonerefs[((1 << 0) * 4) + 1];



};


struct node_active_region {
 unsigned long start_pfn;
 unsigned long end_pfn;
 int nid;
};




extern struct page *mem_map;
# 722 "/usr/src/linux-2.6/include/linux/mmzone.h"
struct bootmem_data;
typedef struct pglist_data {
 struct zone node_zones[4];
 struct zonelist node_zonelists[1];
 int nr_zones;

 struct page *node_mem_map;
# 749 "/usr/src/linux-2.6/include/linux/mmzone.h"
 unsigned long node_start_pfn;
 unsigned long node_present_pages;
 unsigned long node_spanned_pages;

 int node_id;
 nodemask_t reclaim_nodes;
 wait_queue_head_t kswapd_wait;
 wait_queue_head_t pfmemalloc_wait;
 struct task_struct *kswapd;
 int kswapd_max_order;
 enum zone_type classzone_idx;
# 773 "/usr/src/linux-2.6/include/linux/mmzone.h"
} pg_data_t;
# 787 "/usr/src/linux-2.6/include/linux/mmzone.h"
static inline __attribute__((no_instrument_function)) unsigned long pgdat_e=
nd_pfn(pg_data_t *pgdat)
{
 return pgdat->node_start_pfn + pgdat->node_spanned_pages;
}

static inline __attribute__((no_instrument_function)) bool pgdat_is_empty(p=
g_data_t *pgdat)
{
 return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
}

# 1 "/usr/src/linux-2.6/include/linux/memory_hotplug.h" 1



# 1 "/usr/src/linux-2.6/include/linux/mmzone.h" 1
# 5 "/usr/src/linux-2.6/include/linux/memory_hotplug.h" 2




struct page;
struct zone;
struct pglist_data;
struct mem_section;
struct memory_block;
# 201 "/usr/src/linux-2.6/include/linux/memory_hotplug.h"
static inline __attribute__((no_instrument_function)) void pgdat_resize_loc=
k(struct pglist_data *p, unsigned long *f) {}
static inline __attribute__((no_instrument_function)) void pgdat_resize_unl=
ock(struct pglist_data *p, unsigned long *f) {}
static inline __attribute__((no_instrument_function)) void pgdat_resize_ini=
t(struct pglist_data *pgdat) {}

static inline __attribute__((no_instrument_function)) unsigned zone_span_se=
qbegin(struct zone *zone)
{
 return 0;
}
static inline __attribute__((no_instrument_function)) int zone_span_seqretr=
y(struct zone *zone, unsigned iv)
{
 return 0;
}
static inline __attribute__((no_instrument_function)) void zone_span_writel=
ock(struct zone *zone) {}
static inline __attribute__((no_instrument_function)) void zone_span_writeu=
nlock(struct zone *zone) {}
static inline __attribute__((no_instrument_function)) void zone_seqlock_ini=
t(struct zone *zone) {}

static inline __attribute__((no_instrument_function)) int mhp_notimplemente=
d(const char *func)
{
 printk("\001" "4" "%s() called, with CONFIG_MEMORY_HOTPLUG disabled\n", fu=
nc);
 dump_stack();
 return -38;
}

static inline __attribute__((no_instrument_function)) void register_page_bo=
otmem_info_node(struct pglist_data *pgdat)
{
}

static inline __attribute__((no_instrument_function)) void lock_memory_hotp=
lug(void) {}
static inline __attribute__((no_instrument_function)) void unlock_memory_ho=
tplug(void) {}
# 241 "/usr/src/linux-2.6/include/linux/memory_hotplug.h"
static inline __attribute__((no_instrument_function)) int is_mem_section_re=
movable(unsigned long pfn,
     unsigned long nr_pages)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) void try_offline_node=
(int nid) {}

static inline __attribute__((no_instrument_function)) int offline_pages(uns=
igned long start_pfn, unsigned long nr_pages)
{
 return -22;
}

static inline __attribute__((no_instrument_function)) void remove_memory(in=
t nid, u64 start, u64 size) {}


extern int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
  void *arg, int (*func)(struct memory_block *, void *));
extern int mem_online_node(int nid);
extern int add_memory(int nid, u64 start, u64 size);
extern int arch_add_memory(int nid, u64 start, u64 size);
extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
extern bool is_memblock_offlined(struct memory_block *mem);
extern void remove_memory(int nid, u64 start, u64 size);
extern int sparse_add_one_section(struct zone *zone, unsigned long start_pf=
n,
        int nr_pages);
extern void sparse_remove_one_section(struct zone *zone, struct mem_section=
 *ms);
extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
       unsigned long pnum);
# 798 "/usr/src/linux-2.6/include/linux/mmzone.h" 2

extern struct mutex zonelists_mutex;
void build_all_zonelists(pg_data_t *pgdat, struct zone *zone);
void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_i=
dx);
bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
  int classzone_idx, int alloc_flags);
bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
  int classzone_idx, int alloc_flags);
enum memmap_context {
 MEMMAP_EARLY,
 MEMMAP_HOTPLUG,
};
extern int init_currently_empty_zone(struct zone *zone, unsigned long start=
_pfn,
         unsigned long size,
         enum memmap_context context);

extern void lruvec_init(struct lruvec *lruvec);

static inline __attribute__((no_instrument_function)) struct zone *lruvec_z=
one(struct lruvec *lruvec)
{



 return ({ const typeof( ((struct zone *)0)->lruvec ) *__mptr =3D (lruvec);=
 (struct zone *)( (char *)__mptr - __builtin_offsetof(struct zone,lruvec) )=
;});

}




static inline __attribute__((no_instrument_function)) void memory_present(i=
nt nid, unsigned long start, unsigned long end) {}





static inline __attribute__((no_instrument_function)) int local_memory_node=
(int node_id) { return node_id; };
# 846 "/usr/src/linux-2.6/include/linux/mmzone.h"
static inline __attribute__((no_instrument_function)) int populated_zone(st=
ruct zone *zone)
{
 return (!!zone->present_pages);
}

extern int movable_zone;

static inline __attribute__((no_instrument_function)) int zone_movable_is_h=
ighmem(void)
{

 return movable_zone =3D=3D ZONE_HIGHMEM;



}

static inline __attribute__((no_instrument_function)) int is_highmem_idx(en=
um zone_type idx)
{

 return (idx =3D=3D ZONE_HIGHMEM ||
  (idx =3D=3D ZONE_MOVABLE && zone_movable_is_highmem()));



}







static inline __attribute__((no_instrument_function)) int is_highmem(struct=
 zone *zone)
{

 int zone_off =3D (char *)zone - (char *)zone->zone_pgdat->node_zones;
 return zone_off =3D=3D ZONE_HIGHMEM * sizeof(*zone) ||
        (zone_off =3D=3D ZONE_MOVABLE * sizeof(*zone) &&
  zone_movable_is_highmem());



}


struct ctl_table;
int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
     void *, size_t *, loff_t *);
extern int sysctl_lowmem_reserve_ratio[4 -1];
int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
     void *, size_t *, loff_t *);
int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *, int,
     void *, size_t *, loff_t *);
int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
   void *, size_t *, loff_t *);
int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *, int,
   void *, size_t *, loff_t *);

extern int numa_zonelist_order_handler(struct ctl_table *, int,
   void *, size_t *, loff_t *);
extern char numa_zonelist_order[];




extern struct pglist_data contig_page_data;
# 921 "/usr/src/linux-2.6/include/linux/mmzone.h"
extern struct pglist_data *first_online_pgdat(void);
extern struct pglist_data *next_online_pgdat(struct pglist_data *pgdat);
extern struct zone *next_zone(struct zone *zone);
# 953 "/usr/src/linux-2.6/include/linux/mmzone.h"
static inline __attribute__((no_instrument_function)) struct zone *zonelist=
_zone(struct zoneref *zoneref)
{
 return zoneref->zone;
}

static inline __attribute__((no_instrument_function)) int zonelist_zone_idx=
(struct zoneref *zoneref)
{
 return zoneref->zone_idx;
}

static inline __attribute__((no_instrument_function)) int zonelist_node_idx=
(struct zoneref *zoneref)
{




 return 0;

}
# 986 "/usr/src/linux-2.6/include/linux/mmzone.h"
struct zoneref *next_zones_zonelist(struct zoneref *z,
     enum zone_type highest_zoneidx,
     nodemask_t *nodes,
     struct zone **zone);
# 1003 "/usr/src/linux-2.6/include/linux/mmzone.h"
static inline __attribute__((no_instrument_function)) struct zoneref *first=
_zones_zonelist(struct zonelist *zonelist,
     enum zone_type highest_zoneidx,
     nodemask_t *nodes,
     struct zone **zone)
{
 return next_zones_zonelist(zonelist->_zonerefs, highest_zoneidx, nodes,
        zone);
}
# 1234 "/usr/src/linux-2.6/include/linux/mmzone.h"
void memory_present(int nid, unsigned long start, unsigned long end);
unsigned long __attribute__ ((__section__(".init.text"))) __attribute__((__=
cold__)) __attribute__((no_instrument_function)) node_memmap_size_bytes(int=
, unsigned long, unsigned long);
# 1268 "/usr/src/linux-2.6/include/linux/mmzone.h"
static inline __attribute__((no_instrument_function)) int memmap_valid_with=
in(unsigned long pfn,
     struct page *page, struct zone *zone)
{
 return 1;
}
# 33 "/usr/src/linux-2.6/include/linux/topology.h" 2


# 1 "/usr/src/linux-2.6/arch/x86/include/asm/topology.h" 1
# 100 "/usr/src/linux-2.6/arch/x86/include/asm/topology.h"
static inline __attribute__((no_instrument_function)) int numa_node_id(void)
{
 return 0;
}





static inline __attribute__((no_instrument_function)) int early_cpu_to_node=
(int cpu)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) void setup_node_to_cp=
umask_map(void) { }



# 1 "/usr/src/linux-2.6/include/asm-generic/topology.h" 1
# 119 "/usr/src/linux-2.6/arch/x86/include/asm/topology.h" 2

extern const struct cpumask *cpu_coregroup_mask(int cpu);
# 129 "/usr/src/linux-2.6/arch/x86/include/asm/topology.h"
static inline __attribute__((no_instrument_function)) void arch_fix_phys_pa=
ckage_id(int num, u32 slot)
{
}

struct pci_bus;
void x86_pci_root_bus_resources(int bus, struct list_head *resources);
# 146 "/usr/src/linux-2.6/arch/x86/include/asm/topology.h"
static inline __attribute__((no_instrument_function)) int get_mp_bus_to_nod=
e(int busnum)
{
 return 0;
}
static inline __attribute__((no_instrument_function)) void set_mp_bus_to_no=
de(int busnum, int node)
{
}
# 36 "/usr/src/linux-2.6/include/linux/topology.h" 2
# 49 "/usr/src/linux-2.6/include/linux/topology.h"
int arch_update_cpu_topology(void);
# 270 "/usr/src/linux-2.6/include/linux/topology.h"
static inline __attribute__((no_instrument_function)) int numa_mem_id(void)
{
 return numa_node_id();
}
# 39 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/proportions.h" 1
# 12 "/usr/src/linux-2.6/include/linux/proportions.h"
# 1 "/usr/src/linux-2.6/include/linux/percpu_counter.h" 1
# 88 "/usr/src/linux-2.6/include/linux/percpu_counter.h"
struct percpu_counter {
 s64 count;
};

static inline __attribute__((no_instrument_function)) int percpu_counter_in=
it(struct percpu_counter *fbc, s64 amount)
{
 fbc->count =3D amount;
 return 0;
}

static inline __attribute__((no_instrument_function)) void percpu_counter_d=
estroy(struct percpu_counter *fbc)
{
}

static inline __attribute__((no_instrument_function)) void percpu_counter_s=
et(struct percpu_counter *fbc, s64 amount)
{
 fbc->count =3D amount;
}

static inline __attribute__((no_instrument_function)) int percpu_counter_co=
mpare(struct percpu_counter *fbc, s64 rhs)
{
 if (fbc->count > rhs)
  return 1;
 else if (fbc->count < rhs)
  return -1;
 else
  return 0;
}

static inline __attribute__((no_instrument_function)) void
percpu_counter_add(struct percpu_counter *fbc, s64 amount)
{
 __asm__ __volatile__("": : :"memory");
 fbc->count +=3D amount;
 __asm__ __volatile__("": : :"memory");
}

static inline __attribute__((no_instrument_function)) void
__percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
{
 percpu_counter_add(fbc, amount);
}

static inline __attribute__((no_instrument_function)) s64 percpu_counter_re=
ad(struct percpu_counter *fbc)
{
 return fbc->count;
}





static inline __attribute__((no_instrument_function)) s64 percpu_counter_re=
ad_positive(struct percpu_counter *fbc)
{
 return fbc->count;
}

static inline __attribute__((no_instrument_function)) s64 percpu_counter_su=
m_positive(struct percpu_counter *fbc)
{
 return percpu_counter_read_positive(fbc);
}

static inline __attribute__((no_instrument_function)) s64 percpu_counter_su=
m(struct percpu_counter *fbc)
{
 return percpu_counter_read(fbc);
}

static inline __attribute__((no_instrument_function)) int percpu_counter_in=
itialized(struct percpu_counter *fbc)
{
 return 1;
}



static inline __attribute__((no_instrument_function)) void percpu_counter_i=
nc(struct percpu_counter *fbc)
{
 percpu_counter_add(fbc, 1);
}

static inline __attribute__((no_instrument_function)) void percpu_counter_d=
ec(struct percpu_counter *fbc)
{
 percpu_counter_add(fbc, -1);
}

static inline __attribute__((no_instrument_function)) void percpu_counter_s=
ub(struct percpu_counter *fbc, s64 amount)
{
 percpu_counter_add(fbc, -amount);
}
# 13 "/usr/src/linux-2.6/include/linux/proportions.h" 2



struct prop_global {





 int shift;






 struct percpu_counter events;
};






struct prop_descriptor {
 int index;
 struct prop_global pg[2];
 struct mutex mutex;
};

int prop_descriptor_init(struct prop_descriptor *pd, int shift);
void prop_change_shift(struct prop_descriptor *pd, int new_shift);





struct prop_local_percpu {



 struct percpu_counter events;




 int shift;
 unsigned long period;
 raw_spinlock_t lock;
};

int prop_local_init_percpu(struct prop_local_percpu *pl);
void prop_local_destroy_percpu(struct prop_local_percpu *pl);
void __prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu=
 *pl);
void prop_fraction_percpu(struct prop_descriptor *pd, struct prop_local_per=
cpu *pl,
  long *numerator, long *denominator);

static inline __attribute__((no_instrument_function))
void prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu *=
pl)
{
 unsigned long flags;

 do { do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dumm=
y =3D=3D &__dummy2); 1; }); flags =3D arch_local_irq_save(); } while (0); d=
o { } while (0); } while (0);
 __prop_inc_percpu(pd, pl);
 do { if (({ ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__du=
mmy =3D=3D &__dummy2); 1; }); arch_irqs_disabled_flags(flags); })) { do { (=
{ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=3D &__=
dummy2); 1; }); arch_local_irq_restore(flags); } while (0); do { } while (0=
); } else { do { } while (0); do { ({ unsigned long __dummy; typeof(flags) =
__dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); arch_local_irq_restore(=
flags); } while (0); } } while (0);
}
# 93 "/usr/src/linux-2.6/include/linux/proportions.h"
void __prop_inc_percpu_max(struct prop_descriptor *pd,
      struct prop_local_percpu *pl, long frac);






struct prop_local_single {



 unsigned long events;





 unsigned long period;
 int shift;
 raw_spinlock_t lock;
};





int prop_local_init_single(struct prop_local_single *pl);
void prop_local_destroy_single(struct prop_local_single *pl);
void __prop_inc_single(struct prop_descriptor *pd, struct prop_local_single=
 *pl);
void prop_fraction_single(struct prop_descriptor *pd, struct prop_local_sin=
gle *pl,
  long *numerator, long *denominator);

static inline __attribute__((no_instrument_function))
void prop_inc_single(struct prop_descriptor *pd, struct prop_local_single *=
pl)
{
 unsigned long flags;

 do { do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dumm=
y =3D=3D &__dummy2); 1; }); flags =3D arch_local_irq_save(); } while (0); d=
o { } while (0); } while (0);
 __prop_inc_single(pd, pl);
 do { if (({ ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__du=
mmy =3D=3D &__dummy2); 1; }); arch_irqs_disabled_flags(flags); })) { do { (=
{ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=3D &__=
dummy2); 1; }); arch_local_irq_restore(flags); } while (0); do { } while (0=
); } else { do { } while (0); do { ({ unsigned long __dummy; typeof(flags) =
__dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); arch_local_irq_restore(=
flags); } while (0); } } while (0);
}
# 40 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/seccomp.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/seccomp.h" 1
# 40 "/usr/src/linux-2.6/include/uapi/linux/seccomp.h"
struct seccomp_data {
 int nr;
 __u32 arch;
 __u64 instruction_pointer;
 __u64 args[6];
};
# 5 "/usr/src/linux-2.6/include/linux/seccomp.h" 2




# 1 "/usr/src/linux-2.6/arch/x86/include/asm/seccomp.h" 1

# 1 "/usr/src/linux-2.6/arch/x86/include/asm/seccomp_32.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/unistd.h" 1






# 1 "/usr/src/linux-2.6/arch/x86/include/asm/unistd.h" 1



# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/unistd.h" 1
# 5 "/usr/src/linux-2.6/arch/x86/include/asm/unistd.h" 2
# 15 "/usr/src/linux-2.6/arch/x86/include/asm/unistd.h"
# 1 "arch/x86/include/generated/uapi/asm/unistd_32.h" 1
# 16 "/usr/src/linux-2.6/arch/x86/include/asm/unistd.h" 2
# 8 "/usr/src/linux-2.6/include/uapi/linux/unistd.h" 2
# 5 "/usr/src/linux-2.6/arch/x86/include/asm/seccomp_32.h" 2
# 3 "/usr/src/linux-2.6/arch/x86/include/asm/seccomp.h" 2
# 10 "/usr/src/linux-2.6/include/linux/seccomp.h" 2

struct seccomp_filter;
# 23 "/usr/src/linux-2.6/include/linux/seccomp.h"
struct seccomp {
 int mode;
 struct seccomp_filter *filter;
};

extern int __secure_computing(int);
static inline __attribute__((no_instrument_function)) int secure_computing(=
int this_syscall)
{
 if (__builtin_expect(!!(test_ti_thread_flag(current_thread_info(), 8)), 0))
  return __secure_computing(this_syscall);
 return 0;
}


static inline __attribute__((no_instrument_function)) void secure_computing=
_strict(int this_syscall)
{
 do { if (__builtin_expect(!!(secure_computing(this_syscall) !=3D 0), 0)) d=
o { asm volatile("1:\tud2\n" ".pushsection __bug_table,\"a\"\n" "2:\t.long =
1b, %c0\n" "\t.word %c1, 0\n" "\t.org 2b+%c2\n" ".popsection" : : "i" ("/us=
r/src/linux-2.6/include/linux/seccomp.h"), "i" (39), "i" (sizeof(struct bug=
_entry))); __builtin_unreachable(); } while (0); } while(0);
}

extern long prctl_get_seccomp(void);
extern long prctl_set_seccomp(unsigned long, char *);

static inline __attribute__((no_instrument_function)) int seccomp_mode(stru=
ct seccomp *s)
{
 return s->mode;
}
# 77 "/usr/src/linux-2.6/include/linux/seccomp.h"
extern void put_seccomp_filter(struct task_struct *tsk);
extern void get_seccomp_filter(struct task_struct *tsk);
extern u32 seccomp_bpf_load(int off);
# 41 "/usr/src/linux-2.6/include/linux/sched.h" 2

# 1 "/usr/src/linux-2.6/include/linux/rculist.h" 1
# 34 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void __list_add_rcu(s=
truct list_head *new,
  struct list_head *prev, struct list_head *next)
{
 new->next =3D next;
 new->prev =3D prev;
 do { __asm__ __volatile__("": : :"memory"); (((*((struct list_head **)(&(p=
rev)->next))))) =3D (typeof(*(new)) *)((new)); } while (0);
 next->prev =3D new;
}
# 63 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void list_add_rcu(str=
uct list_head *new, struct list_head *head)
{
 __list_add_rcu(new, head, head->next);
}
# 84 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void list_add_tail_rc=
u(struct list_head *new,
     struct list_head *head)
{
 __list_add_rcu(new, head->prev, head);
}
# 114 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void list_del_rcu(str=
uct list_head *entry)
{
 __list_del_entry(entry);
 entry->prev =3D ((void *) 0x00200200 + (0x0UL));
}
# 140 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void hlist_del_init_r=
cu(struct hlist_node *n)
{
 if (!hlist_unhashed(n)) {
  __hlist_del(n);
  n->pprev =3D ((void *)0);
 }
}
# 156 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void list_replace_rcu=
(struct list_head *old,
    struct list_head *new)
{
 new->next =3D old->next;
 new->prev =3D old->prev;
 do { __asm__ __volatile__("": : :"memory"); (((*((struct list_head **)(&(n=
ew->prev)->next))))) =3D (typeof(*(new)) *)((new)); } while (0);
 new->next->prev =3D new;
 old->prev =3D ((void *) 0x00200200 + (0x0UL));
}
# 183 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void list_splice_init=
_rcu(struct list_head *list,
     struct list_head *head,
     void (*sync)(void))
{
 struct list_head *first =3D list->next;
 struct list_head *last =3D list->prev;
 struct list_head *at =3D head->next;

 if (list_empty(list))
  return;



 INIT_LIST_HEAD(list);
# 205 "/usr/src/linux-2.6/include/linux/rculist.h"
 sync();
# 215 "/usr/src/linux-2.6/include/linux/rculist.h"
 last->next =3D at;
 do { __asm__ __volatile__("": : :"memory"); (((*((struct list_head **)(&(h=
ead)->next))))) =3D (typeof(*(first)) *)((first)); } while (0);
 first->prev =3D head;
 at->prev =3D last;
}
# 323 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void hlist_del_rcu(st=
ruct hlist_node *n)
{
 __hlist_del(n);
 n->pprev =3D ((void *) 0x00200200 + (0x0UL));
}
# 336 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void hlist_replace_rc=
u(struct hlist_node *old,
     struct hlist_node *new)
{
 struct hlist_node *next =3D old->next;

 new->next =3D next;
 new->pprev =3D old->pprev;
 do { __asm__ __volatile__("": : :"memory"); ((*(struct hlist_node **)new->=
pprev)) =3D (typeof(*(new)) *)((new)); } while (0);
 if (next)
  new->next->pprev =3D &new->next;
 old->pprev =3D ((void *) 0x00200200 + (0x0UL));
}
# 375 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void hlist_add_head_r=
cu(struct hlist_node *n,
     struct hlist_head *h)
{
 struct hlist_node *first =3D h->first;

 n->next =3D first;
 n->pprev =3D &h->first;
 do { __asm__ __volatile__("": : :"memory"); (((*((struct hlist_node **)(&(=
h)->first))))) =3D (typeof(*(n)) *)((n)); } while (0);
 if (first)
  first->pprev =3D &n->next;
}
# 405 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void hlist_add_before=
_rcu(struct hlist_node *n,
     struct hlist_node *next)
{
 n->pprev =3D next->pprev;
 n->next =3D next;
 do { __asm__ __volatile__("": : :"memory"); (((*((struct hlist_node **)((n=
)->pprev))))) =3D (typeof(*(n)) *)((n)); } while (0);
 next->pprev =3D &n->next;
}
# 432 "/usr/src/linux-2.6/include/linux/rculist.h"
static inline __attribute__((no_instrument_function)) void hlist_add_after_=
rcu(struct hlist_node *prev,
           struct hlist_node *n)
{
 n->next =3D prev->next;
 n->pprev =3D &prev->next;
 do { __asm__ __volatile__("": : :"memory"); (((*((struct hlist_node **)(&(=
prev)->next))))) =3D (typeof(*(n)) *)((n)); } while (0);
 if (n->next)
  n->next->pprev =3D &n->next;
}
# 43 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/rtmutex.h" 1
# 16 "/usr/src/linux-2.6/include/linux/rtmutex.h"
# 1 "/usr/src/linux-2.6/include/linux/plist.h" 1
# 81 "/usr/src/linux-2.6/include/linux/plist.h"
struct plist_head {
 struct list_head node_list;
};

struct plist_node {
 int prio;
 struct list_head prio_list;
 struct list_head node_list;
};
# 116 "/usr/src/linux-2.6/include/linux/plist.h"
static inline __attribute__((no_instrument_function)) void
plist_head_init(struct plist_head *head)
{
 INIT_LIST_HEAD(&head->node_list);
}






static inline __attribute__((no_instrument_function)) void plist_node_init(=
struct plist_node *node, int prio)
{
 node->prio =3D prio;
 INIT_LIST_HEAD(&node->prio_list);
 INIT_LIST_HEAD(&node->node_list);
}

extern void plist_add(struct plist_node *node, struct plist_head *head);
extern void plist_del(struct plist_node *node, struct plist_head *head);
# 181 "/usr/src/linux-2.6/include/linux/plist.h"
static inline __attribute__((no_instrument_function)) int plist_head_empty(=
const struct plist_head *head)
{
 return list_empty(&head->node_list);
}





static inline __attribute__((no_instrument_function)) int plist_node_empty(=
const struct plist_node *node)
{
 return list_empty(&node->node_list);
}
# 237 "/usr/src/linux-2.6/include/linux/plist.h"
static inline __attribute__((no_instrument_function)) struct plist_node *pl=
ist_first(const struct plist_head *head)
{
 return ({ const typeof( ((struct plist_node *)0)->node_list ) *__mptr =3D =
(head->node_list.next); (struct plist_node *)( (char *)__mptr - __builtin_o=
ffsetof(struct plist_node,node_list) );})
                                  ;
}







static inline __attribute__((no_instrument_function)) struct plist_node *pl=
ist_last(const struct plist_head *head)
{
 return ({ const typeof( ((struct plist_node *)0)->node_list ) *__mptr =3D =
(head->node_list.prev); (struct plist_node *)( (char *)__mptr - __builtin_o=
ffsetof(struct plist_node,node_list) );})
                                  ;
}
# 17 "/usr/src/linux-2.6/include/linux/rtmutex.h" 2


extern int max_lock_depth;
# 28 "/usr/src/linux-2.6/include/linux/rtmutex.h"
struct rt_mutex {
 raw_spinlock_t wait_lock;
 struct plist_head wait_list;
 struct task_struct *owner;






};

struct rt_mutex_waiter;
struct hrtimer_sleeper;






 static inline __attribute__((no_instrument_function)) int rt_mutex_debug_c=
heck_no_locks_freed(const void *from,
             unsigned long len)
 {
 return 0;
 }
# 82 "/usr/src/linux-2.6/include/linux/rtmutex.h"
static inline __attribute__((no_instrument_function)) int rt_mutex_is_locke=
d(struct rt_mutex *lock)
{
 return lock->owner !=3D ((void *)0);
}

extern void __rt_mutex_init(struct rt_mutex *lock, const char *name);
extern void rt_mutex_destroy(struct rt_mutex *lock);

extern void rt_mutex_lock(struct rt_mutex *lock);
extern int rt_mutex_lock_interruptible(struct rt_mutex *lock,
      int detect_deadlock);
extern int rt_mutex_timed_lock(struct rt_mutex *lock,
     struct hrtimer_sleeper *timeout,
     int detect_deadlock);

extern int rt_mutex_trylock(struct rt_mutex *lock);

extern void rt_mutex_unlock(struct rt_mutex *lock);
# 44 "/usr/src/linux-2.6/include/linux/sched.h" 2



# 1 "/usr/src/linux-2.6/include/linux/resource.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/linux/resource.h" 1
# 23 "/usr/src/linux-2.6/include/uapi/linux/resource.h"
struct rusage {
 struct timeval ru_utime;
 struct timeval ru_stime;
 long ru_maxrss;
 long ru_ixrss;
 long ru_idrss;
 long ru_isrss;
 long ru_minflt;
 long ru_majflt;
 long ru_nswap;
 long ru_inblock;
 long ru_oublock;
 long ru_msgsnd;
 long ru_msgrcv;
 long ru_nsignals;
 long ru_nvcsw;
 long ru_nivcsw;
};

struct rlimit {
 unsigned long rlim_cur;
 unsigned long rlim_max;
};



struct rlimit64 {
 __u64 rlim_cur;
 __u64 rlim_max;
};
# 77 "/usr/src/linux-2.6/include/uapi/linux/resource.h"
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/resource.h" 1
# 1 "/usr/src/linux-2.6/include/asm-generic/resource.h" 1



# 1 "/usr/src/linux-2.6/include/uapi/asm-generic/resource.h" 1
# 5 "/usr/src/linux-2.6/include/asm-generic/resource.h" 2
# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/resource.h" 2
# 78 "/usr/src/linux-2.6/include/uapi/linux/resource.h" 2
# 5 "/usr/src/linux-2.6/include/linux/resource.h" 2


struct task_struct;

int getrusage(struct task_struct *p, int who, struct rusage *ru);
int do_prlimit(struct task_struct *tsk, unsigned int resource,
  struct rlimit *new_rlim, struct rlimit *old_rlim);
# 48 "/usr/src/linux-2.6/include/linux/sched.h" 2

# 1 "/usr/src/linux-2.6/include/linux/hrtimer.h" 1
# 25 "/usr/src/linux-2.6/include/linux/hrtimer.h"
# 1 "/usr/src/linux-2.6/include/linux/timerqueue.h" 1







struct timerqueue_node {
 struct rb_node node;
 ktime_t expires;
};

struct timerqueue_head {
 struct rb_root head;
 struct timerqueue_node *next;
};


extern void timerqueue_add(struct timerqueue_head *head,
    struct timerqueue_node *node);
extern void timerqueue_del(struct timerqueue_head *head,
    struct timerqueue_node *node);
extern struct timerqueue_node *timerqueue_iterate_next(
      struct timerqueue_node *node);
# 34 "/usr/src/linux-2.6/include/linux/timerqueue.h"
static inline __attribute__((no_instrument_function))
struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
{
 return head->next;
}

static inline __attribute__((no_instrument_function)) void timerqueue_init(=
struct timerqueue_node *node)
{
 ((&node->node)->__rb_parent_color =3D (unsigned long)(&node->node));
}

static inline __attribute__((no_instrument_function)) void timerqueue_init_=
head(struct timerqueue_head *head)
{
 head->head =3D (struct rb_root) { ((void *)0), };
 head->next =3D ((void *)0);
}
# 26 "/usr/src/linux-2.6/include/linux/hrtimer.h" 2

struct hrtimer_clock_base;
struct hrtimer_cpu_base;




enum hrtimer_mode {
 HRTIMER_MODE_ABS =3D 0x0,
 HRTIMER_MODE_REL =3D 0x1,
 HRTIMER_MODE_PINNED =3D 0x02,
 HRTIMER_MODE_ABS_PINNED =3D 0x02,
 HRTIMER_MODE_REL_PINNED =3D 0x03,
};




enum hrtimer_restart {
 HRTIMER_NORESTART,
 HRTIMER_RESTART,
};
# 108 "/usr/src/linux-2.6/include/linux/hrtimer.h"
struct hrtimer {
 struct timerqueue_node node;
 ktime_t _softexpires;
 enum hrtimer_restart (*function)(struct hrtimer *);
 struct hrtimer_clock_base *base;
 unsigned long state;

 int start_pid;
 void *start_site;
 char start_comm[16];

};
# 128 "/usr/src/linux-2.6/include/linux/hrtimer.h"
struct hrtimer_sleeper {
 struct hrtimer timer;
 struct task_struct *task;
};
# 145 "/usr/src/linux-2.6/include/linux/hrtimer.h"
struct hrtimer_clock_base {
 struct hrtimer_cpu_base *cpu_base;
 int index;
 clockid_t clockid;
 struct timerqueue_head active;
 ktime_t resolution;
 ktime_t (*get_time)(void);
 ktime_t softirq_time;
 ktime_t offset;
};

enum hrtimer_base_type {
 HRTIMER_BASE_MONOTONIC,
 HRTIMER_BASE_REALTIME,
 HRTIMER_BASE_BOOTTIME,
 HRTIMER_BASE_TAI,
 HRTIMER_MAX_CLOCK_BASES,
};
# 180 "/usr/src/linux-2.6/include/linux/hrtimer.h"
struct hrtimer_cpu_base {
 raw_spinlock_t lock;
 unsigned int active_bases;
 unsigned int clock_was_set;

 ktime_t expires_next;
 int hres_active;
 int hang_detected;
 unsigned long nr_events;
 unsigned long nr_retries;
 unsigned long nr_hangs;
 ktime_t max_hang_time;

 struct hrtimer_clock_base clock_base[HRTIMER_MAX_CLOCK_BASES];
};

static inline __attribute__((no_instrument_function)) void hrtimer_set_expi=
res(struct hrtimer *timer, ktime_t time)
{
 timer->node.expires =3D time;
 timer->_softexpires =3D time;
}

static inline __attribute__((no_instrument_function)) void hrtimer_set_expi=
res_range(struct hrtimer *timer, ktime_t time, ktime_t delta)
{
 timer->_softexpires =3D time;
 timer->node.expires =3D ktime_add_safe(time, delta);
}

static inline __attribute__((no_instrument_function)) void hrtimer_set_expi=
res_range_ns(struct hrtimer *timer, ktime_t time, unsigned long delta)
{
 timer->_softexpires =3D time;
 timer->node.expires =3D ktime_add_safe(time, ns_to_ktime(delta));
}

static inline __attribute__((no_instrument_function)) void hrtimer_set_expi=
res_tv64(struct hrtimer *timer, s64 tv64)
{
 timer->node.expires.tv64 =3D tv64;
 timer->_softexpires.tv64 =3D tv64;
}

static inline __attribute__((no_instrument_function)) void hrtimer_add_expi=
res(struct hrtimer *timer, ktime_t time)
{
 timer->node.expires =3D ktime_add_safe(timer->node.expires, time);
 timer->_softexpires =3D ktime_add_safe(timer->_softexpires, time);
}

static inline __attribute__((no_instrument_function)) void hrtimer_add_expi=
res_ns(struct hrtimer *timer, u64 ns)
{
 timer->node.expires =3D ({ (ktime_t){ .tv64 =3D (timer->node.expires).tv64=
 + (ns) }; });
 timer->_softexpires =3D ({ (ktime_t){ .tv64 =3D (timer->_softexpires).tv64=
 + (ns) }; });
}

static inline __attribute__((no_instrument_function)) ktime_t hrtimer_get_e=
xpires(const struct hrtimer *timer)
{
 return timer->node.expires;
}

static inline __attribute__((no_instrument_function)) ktime_t hrtimer_get_s=
oftexpires(const struct hrtimer *timer)
{
 return timer->_softexpires;
}

static inline __attribute__((no_instrument_function)) s64 hrtimer_get_expir=
es_tv64(const struct hrtimer *timer)
{
 return timer->node.expires.tv64;
}
static inline __attribute__((no_instrument_function)) s64 hrtimer_get_softe=
xpires_tv64(const struct hrtimer *timer)
{
 return timer->_softexpires.tv64;
}

static inline __attribute__((no_instrument_function)) s64 hrtimer_get_expir=
es_ns(const struct hrtimer *timer)
{
 return ((timer->node.expires).tv64);
}

static inline __attribute__((no_instrument_function)) ktime_t hrtimer_expir=
es_remaining(const struct hrtimer *timer)
{
 return ({ (ktime_t){ .tv64 =3D (timer->node.expires).tv64 - (timer->base->=
get_time()).tv64 }; });
}


struct clock_event_device;

extern void hrtimer_interrupt(struct clock_event_device *dev);




static inline __attribute__((no_instrument_function)) ktime_t hrtimer_cb_ge=
t_time(struct hrtimer *timer)
{
 return timer->base->get_time();
}

static inline __attribute__((no_instrument_function)) int hrtimer_is_hres_a=
ctive(struct hrtimer *timer)
{
 return timer->base->cpu_base->hres_active;
}

extern void hrtimer_peek_ahead_timers(void);
# 292 "/usr/src/linux-2.6/include/linux/hrtimer.h"
extern void clock_was_set_delayed(void);
# 319 "/usr/src/linux-2.6/include/linux/hrtimer.h"
extern void clock_was_set(void);

extern void timerfd_clock_was_set(void);



extern void hrtimers_resume(void);

extern ktime_t ktime_get(void);
extern ktime_t ktime_get_real(void);
extern ktime_t ktime_get_boottime(void);
extern ktime_t ktime_get_monotonic_offset(void);
extern ktime_t ktime_get_clocktai(void);
extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_b=
oot,
      ktime_t *offs_tai);

extern __attribute__((section(".data" ""))) __typeof__(struct tick_device) =
tick_cpu_device;





extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
    enum hrtimer_mode mode);







static inline __attribute__((no_instrument_function)) void hrtimer_init_on_=
stack(struct hrtimer *timer,
      clockid_t which_clock,
      enum hrtimer_mode mode)
{
 hrtimer_init(timer, which_clock, mode);
}
static inline __attribute__((no_instrument_function)) void destroy_hrtimer_=
on_stack(struct hrtimer *timer) { }



extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
    const enum hrtimer_mode mode);
extern int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
   unsigned long range_ns, const enum hrtimer_mode mode);
extern int
__hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
    unsigned long delta_ns,
    const enum hrtimer_mode mode, int wakeup);

extern int hrtimer_cancel(struct hrtimer *timer);
extern int hrtimer_try_to_cancel(struct hrtimer *timer);

static inline __attribute__((no_instrument_function)) int hrtimer_start_exp=
ires(struct hrtimer *timer,
      enum hrtimer_mode mode)
{
 unsigned long delta;
 ktime_t soft, hard;
 soft =3D hrtimer_get_softexpires(timer);
 hard =3D hrtimer_get_expires(timer);
 delta =3D ((({ (ktime_t){ .tv64 =3D (hard).tv64 - (soft).tv64 }; })).tv64);
 return hrtimer_start_range_ns(timer, soft, delta, mode);
}

static inline __attribute__((no_instrument_function)) int hrtimer_restart(s=
truct hrtimer *timer)
{
 return hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
}


extern ktime_t hrtimer_get_remaining(const struct hrtimer *timer);
extern int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp=
);

extern ktime_t hrtimer_get_next_event(void);






static inline __attribute__((no_instrument_function)) int hrtimer_active(co=
nst struct hrtimer *timer)
{
 return timer->state !=3D 0x00;
}




static inline __attribute__((no_instrument_function)) int hrtimer_is_queued=
(struct hrtimer *timer)
{
 return timer->state & 0x01;
}





static inline __attribute__((no_instrument_function)) int hrtimer_callback_=
running(struct hrtimer *timer)
{
 return timer->state & 0x02;
}


extern u64
hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);


static inline __attribute__((no_instrument_function)) u64 hrtimer_forward_n=
ow(struct hrtimer *timer,
          ktime_t interval)
{
 return hrtimer_forward(timer, timer->base->get_time(), interval);
}


extern long hrtimer_nanosleep(struct timespec *rqtp,
         struct timespec *rmtp,
         const enum hrtimer_mode mode,
         const clockid_t clockid);
extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);

extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
     struct task_struct *tsk);

extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
      const enum hrtimer_mode mode);
extern int schedule_hrtimeout_range_clock(ktime_t *expires,
  unsigned long delta, const enum hrtimer_mode mode, int clock);
extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mod=
e);


extern void hrtimer_run_queues(void);
extern void hrtimer_run_pending(void);


extern void __attribute__ ((__section__(".init.text"))) __attribute__((__co=
ld__)) __attribute__((no_instrument_function)) hrtimers_init(void);


extern u64 ktime_divns(const ktime_t kt, s64 div);





extern void sysrq_timer_list_show(void);
# 50 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/task_io_accounting.h" 1
# 11 "/usr/src/linux-2.6/include/linux/task_io_accounting.h"
struct task_io_accounting {


 u64 rchar;

 u64 wchar;

 u64 syscr;

 u64 syscw;







 u64 read_bytes;





 u64 write_bytes;
# 43 "/usr/src/linux-2.6/include/linux/task_io_accounting.h"
 u64 cancelled_write_bytes;

};
# 51 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/latencytop.h" 1
# 13 "/usr/src/linux-2.6/include/linux/latencytop.h"
struct task_struct;
# 42 "/usr/src/linux-2.6/include/linux/latencytop.h"
static inline __attribute__((no_instrument_function)) void
account_scheduler_latency(struct task_struct *task, int usecs, int inter)
{
}

static inline __attribute__((no_instrument_function)) void clear_all_latenc=
y_tracing(struct task_struct *p)
{
}
# 52 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/cred.h" 1
# 17 "/usr/src/linux-2.6/include/linux/cred.h"
# 1 "/usr/src/linux-2.6/include/linux/key.h" 1
# 22 "/usr/src/linux-2.6/include/linux/key.h"
# 1 "/usr/src/linux-2.6/include/linux/sysctl.h" 1
# 28 "/usr/src/linux-2.6/include/linux/sysctl.h"
# 1 "/usr/src/linux-2.6/include/uapi/linux/sysctl.h" 1
# 29 "/usr/src/linux-2.6/include/uapi/linux/sysctl.h"
struct completion;






struct __sysctl_args {
 int *name;
 int nlen;
 void *oldval;
 size_t *oldlenp;
 void *newval;
 size_t newlen;
 unsigned long __unused[4];
};





enum
{
 CTL_KERN=3D1,
 CTL_VM=3D2,
 CTL_NET=3D3,
 CTL_PROC=3D4,
 CTL_FS=3D5,
 CTL_DEBUG=3D6,
 CTL_DEV=3D7,
 CTL_BUS=3D8,
 CTL_ABI=3D9,
 CTL_CPU=3D10,
 CTL_ARLAN=3D254,
 CTL_S390DBF=3D5677,
 CTL_SUNRPC=3D7249,
 CTL_PM=3D9899,
 CTL_FRV=3D9898,
};


enum
{
 CTL_BUS_ISA=3D1
};


enum
{
 INOTIFY_MAX_USER_INSTANCES=3D1,
 INOTIFY_MAX_USER_WATCHES=3D2,
 INOTIFY_MAX_QUEUED_EVENTS=3D3
};


enum
{
 KERN_OSTYPE=3D1,
 KERN_OSRELEASE=3D2,
 KERN_OSREV=3D3,
 KERN_VERSION=3D4,
 KERN_SECUREMASK=3D5,
 KERN_PROF=3D6,
 KERN_NODENAME=3D7,
 KERN_DOMAINNAME=3D8,

 KERN_PANIC=3D15,
 KERN_REALROOTDEV=3D16,

 KERN_SPARC_REBOOT=3D21,
 KERN_CTLALTDEL=3D22,
 KERN_PRINTK=3D23,
 KERN_NAMETRANS=3D24,
 KERN_PPC_HTABRECLAIM=3D25,
 KERN_PPC_ZEROPAGED=3D26,
 KERN_PPC_POWERSAVE_NAP=3D27,
 KERN_MODPROBE=3D28,
 KERN_SG_BIG_BUFF=3D29,
 KERN_ACCT=3D30,
 KERN_PPC_L2CR=3D31,

 KERN_RTSIGNR=3D32,
 KERN_RTSIGMAX=3D33,

 KERN_SHMMAX=3D34,
 KERN_MSGMAX=3D35,
 KERN_MSGMNB=3D36,
 KERN_MSGPOOL=3D37,
 KERN_SYSRQ=3D38,
 KERN_MAX_THREADS=3D39,
  KERN_RANDOM=3D40,
  KERN_SHMALL=3D41,
  KERN_MSGMNI=3D42,
  KERN_SEM=3D43,
  KERN_SPARC_STOP_A=3D44,
  KERN_SHMMNI=3D45,
 KERN_OVERFLOWUID=3D46,
 KERN_OVERFLOWGID=3D47,
 KERN_SHMPATH=3D48,
 KERN_HOTPLUG=3D49,
 KERN_IEEE_EMULATION_WARNINGS=3D50,
 KERN_S390_USER_DEBUG_LOGGING=3D51,
 KERN_CORE_USES_PID=3D52,
 KERN_TAINTED=3D53,
 KERN_CADPID=3D54,
 KERN_PIDMAX=3D55,
   KERN_CORE_PATTERN=3D56,
 KERN_PANIC_ON_OOPS=3D57,
 KERN_HPPA_PWRSW=3D58,
 KERN_HPPA_UNALIGNED=3D59,
 KERN_PRINTK_RATELIMIT=3D60,
 KERN_PRINTK_RATELIMIT_BURST=3D61,
 KERN_PTY=3D62,
 KERN_NGROUPS_MAX=3D63,
 KERN_SPARC_SCONS_PWROFF=3D64,
 KERN_HZ_TIMER=3D65,
 KERN_UNKNOWN_NMI_PANIC=3D66,
 KERN_BOOTLOADER_TYPE=3D67,
 KERN_RANDOMIZE=3D68,
 KERN_SETUID_DUMPABLE=3D69,
 KERN_SPIN_RETRY=3D70,
 KERN_ACPI_VIDEO_FLAGS=3D71,
 KERN_IA64_UNALIGNED=3D72,
 KERN_COMPAT_LOG=3D73,
 KERN_MAX_LOCK_DEPTH=3D74,
 KERN_NMI_WATCHDOG=3D75,
 KERN_PANIC_ON_NMI=3D76,
};




enum
{
 VM_UNUSED1=3D1,
 VM_UNUSED2=3D2,
 VM_UNUSED3=3D3,
 VM_UNUSED4=3D4,
 VM_OVERCOMMIT_MEMORY=3D5,
 VM_UNUSED5=3D6,
 VM_UNUSED7=3D7,
 VM_UNUSED8=3D8,
 VM_UNUSED9=3D9,
 VM_PAGE_CLUSTER=3D10,
 VM_DIRTY_BACKGROUND=3D11,
 VM_DIRTY_RATIO=3D12,
 VM_DIRTY_WB_CS=3D13,
 VM_DIRTY_EXPIRE_CS=3D14,
 VM_NR_PDFLUSH_THREADS=3D15,
 VM_OVERCOMMIT_RATIO=3D16,
 VM_PAGEBUF=3D17,
 VM_HUGETLB_PAGES=3D18,
 VM_SWAPPINESS=3D19,
 VM_LOWMEM_RESERVE_RATIO=3D20,
 VM_MIN_FREE_KBYTES=3D21,
 VM_MAX_MAP_COUNT=3D22,
 VM_LAPTOP_MODE=3D23,
 VM_BLOCK_DUMP=3D24,
 VM_HUGETLB_GROUP=3D25,
 VM_VFS_CACHE_PRESSURE=3D26,
 VM_LEGACY_VA_LAYOUT=3D27,
 VM_SWAP_TOKEN_TIMEOUT=3D28,
 VM_DROP_PAGECACHE=3D29,
 VM_PERCPU_PAGELIST_FRACTION=3D30,
 VM_ZONE_RECLAIM_MODE=3D31,
 VM_MIN_UNMAPPED=3D32,
 VM_PANIC_ON_OOM=3D33,
 VM_VDSO_ENABLED=3D34,
 VM_MIN_SLAB=3D35,
};



enum
{
 NET_CORE=3D1,
 NET_ETHER=3D2,
 NET_802=3D3,
 NET_UNIX=3D4,
 NET_IPV4=3D5,
 NET_IPX=3D6,
 NET_ATALK=3D7,
 NET_NETROM=3D8,
 NET_AX25=3D9,
 NET_BRIDGE=3D10,
 NET_ROSE=3D11,
 NET_IPV6=3D12,
 NET_X25=3D13,
 NET_TR=3D14,
 NET_DECNET=3D15,
 NET_ECONET=3D16,
 NET_SCTP=3D17,
 NET_LLC=3D18,
 NET_NETFILTER=3D19,
 NET_DCCP=3D20,
 NET_IRDA=3D412,
};


enum
{
 RANDOM_POOLSIZE=3D1,
 RANDOM_ENTROPY_COUNT=3D2,
 RANDOM_READ_THRESH=3D3,
 RANDOM_WRITE_THRESH=3D4,
 RANDOM_BOOT_ID=3D5,
 RANDOM_UUID=3D6
};


enum
{
 PTY_MAX=3D1,
 PTY_NR=3D2
};


enum
{
 BUS_ISA_MEM_BASE=3D1,
 BUS_ISA_PORT_BASE=3D2,
 BUS_ISA_PORT_SHIFT=3D3
};


enum
{
 NET_CORE_WMEM_MAX=3D1,
 NET_CORE_RMEM_MAX=3D2,
 NET_CORE_WMEM_DEFAULT=3D3,
 NET_CORE_RMEM_DEFAULT=3D4,

 NET_CORE_MAX_BACKLOG=3D6,
 NET_CORE_FASTROUTE=3D7,
 NET_CORE_MSG_COST=3D8,
 NET_CORE_MSG_BURST=3D9,
 NET_CORE_OPTMEM_MAX=3D10,
 NET_CORE_HOT_LIST_LENGTH=3D11,
 NET_CORE_DIVERT_VERSION=3D12,
 NET_CORE_NO_CONG_THRESH=3D13,
 NET_CORE_NO_CONG=3D14,
 NET_CORE_LO_CONG=3D15,
 NET_CORE_MOD_CONG=3D16,
 NET_CORE_DEV_WEIGHT=3D17,
 NET_CORE_SOMAXCONN=3D18,
 NET_CORE_BUDGET=3D19,
 NET_CORE_AEVENT_ETIME=3D20,
 NET_CORE_AEVENT_RSEQTH=3D21,
 NET_CORE_WARNINGS=3D22,
};







enum
{
 NET_UNIX_DESTROY_DELAY=3D1,
 NET_UNIX_DELETE_DELAY=3D2,
 NET_UNIX_MAX_DGRAM_QLEN=3D3,
};


enum
{
 NET_NF_CONNTRACK_MAX=3D1,
 NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT=3D2,
 NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV=3D3,
 NET_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED=3D4,
 NET_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT=3D5,
 NET_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT=3D6,
 NET_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK=3D7,
 NET_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT=3D8,
 NET_NF_CONNTRACK_TCP_TIMEOUT_CLOSE=3D9,
 NET_NF_CONNTRACK_UDP_TIMEOUT=3D10,
 NET_NF_CONNTRACK_UDP_TIMEOUT_STREAM=3D11,
 NET_NF_CONNTRACK_ICMP_TIMEOUT=3D12,
 NET_NF_CONNTRACK_GENERIC_TIMEOUT=3D13,
 NET_NF_CONNTRACK_BUCKETS=3D14,
 NET_NF_CONNTRACK_LOG_INVALID=3D15,
 NET_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS=3D16,
 NET_NF_CONNTRACK_TCP_LOOSE=3D17,
 NET_NF_CONNTRACK_TCP_BE_LIBERAL=3D18,
 NET_NF_CONNTRACK_TCP_MAX_RETRANS=3D19,
 NET_NF_CONNTRACK_SCTP_TIMEOUT_CLOSED=3D20,
 NET_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_WAIT=3D21,
 NET_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_ECHOED=3D22,
 NET_NF_CONNTRACK_SCTP_TIMEOUT_ESTABLISHED=3D23,
 NET_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_SENT=3D24,
 NET_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD=3D25,
 NET_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT=3D26,
 NET_NF_CONNTRACK_COUNT=3D27,
 NET_NF_CONNTRACK_ICMPV6_TIMEOUT=3D28,
 NET_NF_CONNTRACK_FRAG6_TIMEOUT=3D29,
 NET_NF_CONNTRACK_FRAG6_LOW_THRESH=3D30,
 NET_NF_CONNTRACK_FRAG6_HIGH_THRESH=3D31,
 NET_NF_CONNTRACK_CHECKSUM=3D32,
};


enum
{

 NET_IPV4_FORWARD=3D8,
 NET_IPV4_DYNADDR=3D9,

 NET_IPV4_CONF=3D16,
 NET_IPV4_NEIGH=3D17,
 NET_IPV4_ROUTE=3D18,
 NET_IPV4_FIB_HASH=3D19,
 NET_IPV4_NETFILTER=3D20,

 NET_IPV4_TCP_TIMESTAMPS=3D33,
 NET_IPV4_TCP_WINDOW_SCALING=3D34,
 NET_IPV4_TCP_SACK=3D35,
 NET_IPV4_TCP_RETRANS_COLLAPSE=3D36,
 NET_IPV4_DEFAULT_TTL=3D37,
 NET_IPV4_AUTOCONFIG=3D38,
 NET_IPV4_NO_PMTU_DISC=3D39,
 NET_IPV4_TCP_SYN_RETRIES=3D40,
 NET_IPV4_IPFRAG_HIGH_THRESH=3D41,
 NET_IPV4_IPFRAG_LOW_THRESH=3D42,
 NET_IPV4_IPFRAG_TIME=3D43,
 NET_IPV4_TCP_MAX_KA_PROBES=3D44,
 NET_IPV4_TCP_KEEPALIVE_TIME=3D45,
 NET_IPV4_TCP_KEEPALIVE_PROBES=3D46,
 NET_IPV4_TCP_RETRIES1=3D47,
 NET_IPV4_TCP_RETRIES2=3D48,
 NET_IPV4_TCP_FIN_TIMEOUT=3D49,
 NET_IPV4_IP_MASQ_DEBUG=3D50,
 NET_TCP_SYNCOOKIES=3D51,
 NET_TCP_STDURG=3D52,
 NET_TCP_RFC1337=3D53,
 NET_TCP_SYN_TAILDROP=3D54,
 NET_TCP_MAX_SYN_BACKLOG=3D55,
 NET_IPV4_LOCAL_PORT_RANGE=3D56,
 NET_IPV4_ICMP_ECHO_IGNORE_ALL=3D57,
 NET_IPV4_ICMP_ECHO_IGNORE_BROADCASTS=3D58,
 NET_IPV4_ICMP_SOURCEQUENCH_RATE=3D59,
 NET_IPV4_ICMP_DESTUNREACH_RATE=3D60,
 NET_IPV4_ICMP_TIMEEXCEED_RATE=3D61,
 NET_IPV4_ICMP_PARAMPROB_RATE=3D62,
 NET_IPV4_ICMP_ECHOREPLY_RATE=3D63,
 NET_IPV4_ICMP_IGNORE_BOGUS_ERROR_RESPONSES=3D64,
 NET_IPV4_IGMP_MAX_MEMBERSHIPS=3D65,
 NET_TCP_TW_RECYCLE=3D66,
 NET_IPV4_ALWAYS_DEFRAG=3D67,
 NET_IPV4_TCP_KEEPALIVE_INTVL=3D68,
 NET_IPV4_INET_PEER_THRESHOLD=3D69,
 NET_IPV4_INET_PEER_MINTTL=3D70,
 NET_IPV4_INET_PEER_MAXTTL=3D71,
 NET_IPV4_INET_PEER_GC_MINTIME=3D72,
 NET_IPV4_INET_PEER_GC_MAXTIME=3D73,
 NET_TCP_ORPHAN_RETRIES=3D74,
 NET_TCP_ABORT_ON_OVERFLOW=3D75,
 NET_TCP_SYNACK_RETRIES=3D76,
 NET_TCP_MAX_ORPHANS=3D77,
 NET_TCP_MAX_TW_BUCKETS=3D78,
 NET_TCP_FACK=3D79,
 NET_TCP_REORDERING=3D80,
 NET_TCP_ECN=3D81,
 NET_TCP_DSACK=3D82,
 NET_TCP_MEM=3D83,
 NET_TCP_WMEM=3D84,
 NET_TCP_RMEM=3D85,
 NET_TCP_APP_WIN=3D86,
 NET_TCP_ADV_WIN_SCALE=3D87,
 NET_IPV4_NONLOCAL_BIND=3D88,
 NET_IPV4_ICMP_RATELIMIT=3D89,
 NET_IPV4_ICMP_RATEMASK=3D90,
 NET_TCP_TW_REUSE=3D91,
 NET_TCP_FRTO=3D92,
 NET_TCP_LOW_LATENCY=3D93,
 NET_IPV4_IPFRAG_SECRET_INTERVAL=3D94,
 NET_IPV4_IGMP_MAX_MSF=3D96,
 NET_TCP_NO_METRICS_SAVE=3D97,
 NET_TCP_DEFAULT_WIN_SCALE=3D105,
 NET_TCP_MODERATE_RCVBUF=3D106,
 NET_TCP_TSO_WIN_DIVISOR=3D107,
 NET_TCP_BIC_BETA=3D108,
 NET_IPV4_ICMP_ERRORS_USE_INBOUND_IFADDR=3D109,
 NET_TCP_CONG_CONTROL=3D110,
 NET_TCP_ABC=3D111,
 NET_IPV4_IPFRAG_MAX_DIST=3D112,
  NET_TCP_MTU_PROBING=3D113,
 NET_TCP_BASE_MSS=3D114,
 NET_IPV4_TCP_WORKAROUND_SIGNED_WINDOWS=3D115,
 NET_TCP_DMA_COPYBREAK=3D116,
 NET_TCP_SLOW_START_AFTER_IDLE=3D117,
 NET_CIPSOV4_CACHE_ENABLE=3D118,
 NET_CIPSOV4_CACHE_BUCKET_SIZE=3D119,
 NET_CIPSOV4_RBM_OPTFMT=3D120,
 NET_CIPSOV4_RBM_STRICTVALID=3D121,
 NET_TCP_AVAIL_CONG_CONTROL=3D122,
 NET_TCP_ALLOWED_CONG_CONTROL=3D123,
 NET_TCP_MAX_SSTHRESH=3D124,
 NET_TCP_FRTO_RESPONSE=3D125,
};

enum {
 NET_IPV4_ROUTE_FLUSH=3D1,
 NET_IPV4_ROUTE_MIN_DELAY=3D2,
 NET_IPV4_ROUTE_MAX_DELAY=3D3,
 NET_IPV4_ROUTE_GC_THRESH=3D4,
 NET_IPV4_ROUTE_MAX_SIZE=3D5,
 NET_IPV4_ROUTE_GC_MIN_INTERVAL=3D6,
 NET_IPV4_ROUTE_GC_TIMEOUT=3D7,
 NET_IPV4_ROUTE_GC_INTERVAL=3D8,
 NET_IPV4_ROUTE_REDIRECT_LOAD=3D9,
 NET_IPV4_ROUTE_REDIRECT_NUMBER=3D10,
 NET_IPV4_ROUTE_REDIRECT_SILENCE=3D11,
 NET_IPV4_ROUTE_ERROR_COST=3D12,
 NET_IPV4_ROUTE_ERROR_BURST=3D13,
 NET_IPV4_ROUTE_GC_ELASTICITY=3D14,
 NET_IPV4_ROUTE_MTU_EXPIRES=3D15,
 NET_IPV4_ROUTE_MIN_PMTU=3D16,
 NET_IPV4_ROUTE_MIN_ADVMSS=3D17,
 NET_IPV4_ROUTE_SECRET_INTERVAL=3D18,
 NET_IPV4_ROUTE_GC_MIN_INTERVAL_MS=3D19,
};

enum
{
 NET_PROTO_CONF_ALL=3D-2,
 NET_PROTO_CONF_DEFAULT=3D-3


};

enum
{
 NET_IPV4_CONF_FORWARDING=3D1,
 NET_IPV4_CONF_MC_FORWARDING=3D2,
 NET_IPV4_CONF_PROXY_ARP=3D3,
 NET_IPV4_CONF_ACCEPT_REDIRECTS=3D4,
 NET_IPV4_CONF_SECURE_REDIRECTS=3D5,
 NET_IPV4_CONF_SEND_REDIRECTS=3D6,
 NET_IPV4_CONF_SHARED_MEDIA=3D7,
 NET_IPV4_CONF_RP_FILTER=3D8,
 NET_IPV4_CONF_ACCEPT_SOURCE_ROUTE=3D9,
 NET_IPV4_CONF_BOOTP_RELAY=3D10,
 NET_IPV4_CONF_LOG_MARTIANS=3D11,
 NET_IPV4_CONF_TAG=3D12,
 NET_IPV4_CONF_ARPFILTER=3D13,
 NET_IPV4_CONF_MEDIUM_ID=3D14,
 NET_IPV4_CONF_NOXFRM=3D15,
 NET_IPV4_CONF_NOPOLICY=3D16,
 NET_IPV4_CONF_FORCE_IGMP_VERSION=3D17,
 NET_IPV4_CONF_ARP_ANNOUNCE=3D18,
 NET_IPV4_CONF_ARP_IGNORE=3D19,
 NET_IPV4_CONF_PROMOTE_SECONDARIES=3D20,
 NET_IPV4_CONF_ARP_ACCEPT=3D21,
 NET_IPV4_CONF_ARP_NOTIFY=3D22,
};


enum
{
 NET_IPV4_NF_CONNTRACK_MAX=3D1,
 NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT=3D2,
 NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV=3D3,
 NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED=3D4,
 NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT=3D5,
 NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT=3D6,
 NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK=3D7,
 NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT=3D8,
 NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE=3D9,
 NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT=3D10,
 NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM=3D11,
 NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT=3D12,
 NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT=3D13,
 NET_IPV4_NF_CONNTRACK_BUCKETS=3D14,
 NET_IPV4_NF_CONNTRACK_LOG_INVALID=3D15,
 NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS=3D16,
 NET_IPV4_NF_CONNTRACK_TCP_LOOSE=3D17,
 NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL=3D18,
 NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS=3D19,
  NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_CLOSED=3D20,
  NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_WAIT=3D21,
  NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_ECHOED=3D22,
  NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_ESTABLISHED=3D23,
  NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_SENT=3D24,
  NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD=3D25,
  NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT=3D26,
 NET_IPV4_NF_CONNTRACK_COUNT=3D27,
 NET_IPV4_NF_CONNTRACK_CHECKSUM=3D28,
};


enum {
 NET_IPV6_CONF=3D16,
 NET_IPV6_NEIGH=3D17,
 NET_IPV6_ROUTE=3D18,
 NET_IPV6_ICMP=3D19,
 NET_IPV6_BINDV6ONLY=3D20,
 NET_IPV6_IP6FRAG_HIGH_THRESH=3D21,
 NET_IPV6_IP6FRAG_LOW_THRESH=3D22,
 NET_IPV6_IP6FRAG_TIME=3D23,
 NET_IPV6_IP6FRAG_SECRET_INTERVAL=3D24,
 NET_IPV6_MLD_MAX_MSF=3D25,
};

enum {
 NET_IPV6_ROUTE_FLUSH=3D1,
 NET_IPV6_ROUTE_GC_THRESH=3D2,
 NET_IPV6_ROUTE_MAX_SIZE=3D3,
 NET_IPV6_ROUTE_GC_MIN_INTERVAL=3D4,
 NET_IPV6_ROUTE_GC_TIMEOUT=3D5,
 NET_IPV6_ROUTE_GC_INTERVAL=3D6,
 NET_IPV6_ROUTE_GC_ELASTICITY=3D7,
 NET_IPV6_ROUTE_MTU_EXPIRES=3D8,
 NET_IPV6_ROUTE_MIN_ADVMSS=3D9,
 NET_IPV6_ROUTE_GC_MIN_INTERVAL_MS=3D10
};

enum {
 NET_IPV6_FORWARDING=3D1,
 NET_IPV6_HOP_LIMIT=3D2,
 NET_IPV6_MTU=3D3,
 NET_IPV6_ACCEPT_RA=3D4,
 NET_IPV6_ACCEPT_REDIRECTS=3D5,
 NET_IPV6_AUTOCONF=3D6,
 NET_IPV6_DAD_TRANSMITS=3D7,
 NET_IPV6_RTR_SOLICITS=3D8,
 NET_IPV6_RTR_SOLICIT_INTERVAL=3D9,
 NET_IPV6_RTR_SOLICIT_DELAY=3D10,
 NET_IPV6_USE_TEMPADDR=3D11,
 NET_IPV6_TEMP_VALID_LFT=3D12,
 NET_IPV6_TEMP_PREFERED_LFT=3D13,
 NET_IPV6_REGEN_MAX_RETRY=3D14,
 NET_IPV6_MAX_DESYNC_FACTOR=3D15,
 NET_IPV6_MAX_ADDRESSES=3D16,
 NET_IPV6_FORCE_MLD_VERSION=3D17,
 NET_IPV6_ACCEPT_RA_DEFRTR=3D18,
 NET_IPV6_ACCEPT_RA_PINFO=3D19,
 NET_IPV6_ACCEPT_RA_RTR_PREF=3D20,
 NET_IPV6_RTR_PROBE_INTERVAL=3D21,
 NET_IPV6_ACCEPT_RA_RT_INFO_MAX_PLEN=3D22,
 NET_IPV6_PROXY_NDP=3D23,
 NET_IPV6_ACCEPT_SOURCE_ROUTE=3D25,
 __NET_IPV6_MAX
};


enum {
 NET_IPV6_ICMP_RATELIMIT=3D1
};


enum {
 NET_NEIGH_MCAST_SOLICIT=3D1,
 NET_NEIGH_UCAST_SOLICIT=3D2,
 NET_NEIGH_APP_SOLICIT=3D3,
 NET_NEIGH_RETRANS_TIME=3D4,
 NET_NEIGH_REACHABLE_TIME=3D5,
 NET_NEIGH_DELAY_PROBE_TIME=3D6,
 NET_NEIGH_GC_STALE_TIME=3D7,
 NET_NEIGH_UNRES_QLEN=3D8,
 NET_NEIGH_PROXY_QLEN=3D9,
 NET_NEIGH_ANYCAST_DELAY=3D10,
 NET_NEIGH_PROXY_DELAY=3D11,
 NET_NEIGH_LOCKTIME=3D12,
 NET_NEIGH_GC_INTERVAL=3D13,
 NET_NEIGH_GC_THRESH1=3D14,
 NET_NEIGH_GC_THRESH2=3D15,
 NET_NEIGH_GC_THRESH3=3D16,
 NET_NEIGH_RETRANS_TIME_MS=3D17,
 NET_NEIGH_REACHABLE_TIME_MS=3D18,
};


enum {
 NET_DCCP_DEFAULT=3D1,
};


enum {
 NET_IPX_PPROP_BROADCASTING=3D1,
 NET_IPX_FORWARDING=3D2
};


enum {
 NET_LLC2=3D1,
 NET_LLC_STATION=3D2,
};


enum {
 NET_LLC2_TIMEOUT=3D1,
};


enum {
 NET_LLC_STATION_ACK_TIMEOUT=3D1,
};


enum {
 NET_LLC2_ACK_TIMEOUT=3D1,
 NET_LLC2_P_TIMEOUT=3D2,
 NET_LLC2_REJ_TIMEOUT=3D3,
 NET_LLC2_BUSY_TIMEOUT=3D4,
};


enum {
 NET_ATALK_AARP_EXPIRY_TIME=3D1,
 NET_ATALK_AARP_TICK_TIME=3D2,
 NET_ATALK_AARP_RETRANSMIT_LIMIT=3D3,
 NET_ATALK_AARP_RESOLVE_TIME=3D4
};



enum {
 NET_NETROM_DEFAULT_PATH_QUALITY=3D1,
 NET_NETROM_OBSOLESCENCE_COUNT_INITIALISER=3D2,
 NET_NETROM_NETWORK_TTL_INITIALISER=3D3,
 NET_NETROM_TRANSPORT_TIMEOUT=3D4,
 NET_NETROM_TRANSPORT_MAXIMUM_TRIES=3D5,
 NET_NETROM_TRANSPORT_ACKNOWLEDGE_DELAY=3D6,
 NET_NETROM_TRANSPORT_BUSY_DELAY=3D7,
 NET_NETROM_TRANSPORT_REQUESTED_WINDOW_SIZE=3D8,
 NET_NETROM_TRANSPORT_NO_ACTIVITY_TIMEOUT=3D9,
 NET_NETROM_ROUTING_CONTROL=3D10,
 NET_NETROM_LINK_FAILS_COUNT=3D11,
 NET_NETROM_RESET=3D12
};


enum {
 NET_AX25_IP_DEFAULT_MODE=3D1,
 NET_AX25_DEFAULT_MODE=3D2,
 NET_AX25_BACKOFF_TYPE=3D3,
 NET_AX25_CONNECT_MODE=3D4,
 NET_AX25_STANDARD_WINDOW=3D5,
 NET_AX25_EXTENDED_WINDOW=3D6,
 NET_AX25_T1_TIMEOUT=3D7,
 NET_AX25_T2_TIMEOUT=3D8,
 NET_AX25_T3_TIMEOUT=3D9,
 NET_AX25_IDLE_TIMEOUT=3D10,
 NET_AX25_N2=3D11,
 NET_AX25_PACLEN=3D12,
 NET_AX25_PROTOCOL=3D13,
 NET_AX25_DAMA_SLAVE_TIMEOUT=3D14
};


enum {
 NET_ROSE_RESTART_REQUEST_TIMEOUT=3D1,
 NET_ROSE_CALL_REQUEST_TIMEOUT=3D2,
 NET_ROSE_RESET_REQUEST_TIMEOUT=3D3,
 NET_ROSE_CLEAR_REQUEST_TIMEOUT=3D4,
 NET_ROSE_ACK_HOLD_BACK_TIMEOUT=3D5,
 NET_ROSE_ROUTING_CONTROL=3D6,
 NET_ROSE_LINK_FAIL_TIMEOUT=3D7,
 NET_ROSE_MAX_VCS=3D8,
 NET_ROSE_WINDOW_SIZE=3D9,
 NET_ROSE_NO_ACTIVITY_TIMEOUT=3D10
};


enum {
 NET_X25_RESTART_REQUEST_TIMEOUT=3D1,
 NET_X25_CALL_REQUEST_TIMEOUT=3D2,
 NET_X25_RESET_REQUEST_TIMEOUT=3D3,
 NET_X25_CLEAR_REQUEST_TIMEOUT=3D4,
 NET_X25_ACK_HOLD_BACK_TIMEOUT=3D5,
 NET_X25_FORWARD=3D6
};


enum
{
 NET_TR_RIF_TIMEOUT=3D1
};


enum {
 NET_DECNET_NODE_TYPE =3D 1,
 NET_DECNET_NODE_ADDRESS =3D 2,
 NET_DECNET_NODE_NAME =3D 3,
 NET_DECNET_DEFAULT_DEVICE =3D 4,
 NET_DECNET_TIME_WAIT =3D 5,
 NET_DECNET_DN_COUNT =3D 6,
 NET_DECNET_DI_COUNT =3D 7,
 NET_DECNET_DR_COUNT =3D 8,
 NET_DECNET_DST_GC_INTERVAL =3D 9,
 NET_DECNET_CONF =3D 10,
 NET_DECNET_NO_FC_MAX_CWND =3D 11,
 NET_DECNET_MEM =3D 12,
 NET_DECNET_RMEM =3D 13,
 NET_DECNET_WMEM =3D 14,
 NET_DECNET_DEBUG_LEVEL =3D 255
};


enum {
 NET_DECNET_CONF_LOOPBACK =3D -2,
 NET_DECNET_CONF_DDCMP =3D -3,
 NET_DECNET_CONF_PPP =3D -4,
 NET_DECNET_CONF_X25 =3D -5,
 NET_DECNET_CONF_GRE =3D -6,
 NET_DECNET_CONF_ETHER =3D -7


};


enum {
 NET_DECNET_CONF_DEV_PRIORITY =3D 1,
 NET_DECNET_CONF_DEV_T1 =3D 2,
 NET_DECNET_CONF_DEV_T2 =3D 3,
 NET_DECNET_CONF_DEV_T3 =3D 4,
 NET_DECNET_CONF_DEV_FORWARDING =3D 5,
 NET_DECNET_CONF_DEV_BLKSIZE =3D 6,
 NET_DECNET_CONF_DEV_STATE =3D 7
};


enum {
 NET_SCTP_RTO_INITIAL =3D 1,
 NET_SCTP_RTO_MIN =3D 2,
 NET_SCTP_RTO_MAX =3D 3,
 NET_SCTP_RTO_ALPHA =3D 4,
 NET_SCTP_RTO_BETA =3D 5,
 NET_SCTP_VALID_COOKIE_LIFE =3D 6,
 NET_SCTP_ASSOCIATION_MAX_RETRANS =3D 7,
 NET_SCTP_PATH_MAX_RETRANS =3D 8,
 NET_SCTP_MAX_INIT_RETRANSMITS =3D 9,
 NET_SCTP_HB_INTERVAL =3D 10,
 NET_SCTP_PRESERVE_ENABLE =3D 11,
 NET_SCTP_MAX_BURST =3D 12,
 NET_SCTP_ADDIP_ENABLE =3D 13,
 NET_SCTP_PRSCTP_ENABLE =3D 14,
 NET_SCTP_SNDBUF_POLICY =3D 15,
 NET_SCTP_SACK_TIMEOUT =3D 16,
 NET_SCTP_RCVBUF_POLICY =3D 17,
};


enum {
 NET_BRIDGE_NF_CALL_ARPTABLES =3D 1,
 NET_BRIDGE_NF_CALL_IPTABLES =3D 2,
 NET_BRIDGE_NF_CALL_IP6TABLES =3D 3,
 NET_BRIDGE_NF_FILTER_VLAN_TAGGED =3D 4,
 NET_BRIDGE_NF_FILTER_PPPOE_TAGGED =3D 5,
};


enum {
 NET_IRDA_DISCOVERY=3D1,
 NET_IRDA_DEVNAME=3D2,
 NET_IRDA_DEBUG=3D3,
 NET_IRDA_FAST_POLL=3D4,
 NET_IRDA_DISCOVERY_SLOTS=3D5,
 NET_IRDA_DISCOVERY_TIMEOUT=3D6,
 NET_IRDA_SLOT_TIMEOUT=3D7,
 NET_IRDA_MAX_BAUD_RATE=3D8,
 NET_IRDA_MIN_TX_TURN_TIME=3D9,
 NET_IRDA_MAX_TX_DATA_SIZE=3D10,
 NET_IRDA_MAX_TX_WINDOW=3D11,
 NET_IRDA_MAX_NOREPLY_TIME=3D12,
 NET_IRDA_WARN_NOREPLY_TIME=3D13,
 NET_IRDA_LAP_KEEPALIVE_TIME=3D14,
};



enum
{
 FS_NRINODE=3D1,
 FS_STATINODE=3D2,
 FS_MAXINODE=3D3,
 FS_NRDQUOT=3D4,
 FS_MAXDQUOT=3D5,
 FS_NRFILE=3D6,
 FS_MAXFILE=3D7,
 FS_DENTRY=3D8,
 FS_NRSUPER=3D9,
 FS_MAXSUPER=3D10,
 FS_OVERFLOWUID=3D11,
 FS_OVERFLOWGID=3D12,
 FS_LEASES=3D13,
 FS_DIR_NOTIFY=3D14,
 FS_LEASE_TIME=3D15,
 FS_DQSTATS=3D16,
 FS_XFS=3D17,
 FS_AIO_NR=3D18,
 FS_AIO_MAX_NR=3D19,
 FS_INOTIFY=3D20,
 FS_OCFS2=3D988,
};


enum {
 FS_DQ_LOOKUPS =3D 1,
 FS_DQ_DROPS =3D 2,
 FS_DQ_READS =3D 3,
 FS_DQ_WRITES =3D 4,
 FS_DQ_CACHE_HITS =3D 5,
 FS_DQ_ALLOCATED =3D 6,
 FS_DQ_FREE =3D 7,
 FS_DQ_SYNCS =3D 8,
 FS_DQ_WARNINGS =3D 9,
};




enum {
 DEV_CDROM=3D1,
 DEV_HWMON=3D2,
 DEV_PARPORT=3D3,
 DEV_RAID=3D4,
 DEV_MAC_HID=3D5,
 DEV_SCSI=3D6,
 DEV_IPMI=3D7,
};


enum {
 DEV_CDROM_INFO=3D1,
 DEV_CDROM_AUTOCLOSE=3D2,
 DEV_CDROM_AUTOEJECT=3D3,
 DEV_CDROM_DEBUG=3D4,
 DEV_CDROM_LOCK=3D5,
 DEV_CDROM_CHECK_MEDIA=3D6
};


enum {
 DEV_PARPORT_DEFAULT=3D-3
};


enum {
 DEV_RAID_SPEED_LIMIT_MIN=3D1,
 DEV_RAID_SPEED_LIMIT_MAX=3D2
};


enum {
 DEV_PARPORT_DEFAULT_TIMESLICE=3D1,
 DEV_PARPORT_DEFAULT_SPINTIME=3D2
};


enum {
 DEV_PARPORT_SPINTIME=3D1,
 DEV_PARPORT_BASE_ADDR=3D2,
 DEV_PARPORT_IRQ=3D3,
 DEV_PARPORT_DMA=3D4,
 DEV_PARPORT_MODES=3D5,
 DEV_PARPORT_DEVICES=3D6,
 DEV_PARPORT_AUTOPROBE=3D16
};


enum {
 DEV_PARPORT_DEVICES_ACTIVE=3D-3,
};


enum {
 DEV_PARPORT_DEVICE_TIMESLICE=3D1,
};


enum {
 DEV_MAC_HID_KEYBOARD_SENDS_LINUX_KEYCODES=3D1,
 DEV_MAC_HID_KEYBOARD_LOCK_KEYCODES=3D2,
 DEV_MAC_HID_MOUSE_BUTTON_EMULATION=3D3,
 DEV_MAC_HID_MOUSE_BUTTON2_KEYCODE=3D4,
 DEV_MAC_HID_MOUSE_BUTTON3_KEYCODE=3D5,
 DEV_MAC_HID_ADB_MOUSE_SENDS_KEYCODES=3D6
};


enum {
 DEV_SCSI_LOGGING_LEVEL=3D1,
};


enum {
 DEV_IPMI_POWEROFF_POWERCYCLE=3D1,
};


enum
{
 ABI_DEFHANDLER_COFF=3D1,
 ABI_DEFHANDLER_ELF=3D2,
 ABI_DEFHANDLER_LCALL7=3D3,
 ABI_DEFHANDLER_LIBCSO=3D4,
 ABI_TRACE=3D5,
 ABI_FAKE_UTSNAME=3D6,
};
# 29 "/usr/src/linux-2.6/include/linux/sysctl.h" 2


struct ctl_table;
struct nsproxy;
struct ctl_table_root;
struct ctl_table_header;
struct ctl_dir;

typedef struct ctl_table ctl_table;

typedef int proc_handler (struct ctl_table *ctl, int write,
     void *buffer, size_t *lenp, loff_t *ppos);

extern int proc_dostring(struct ctl_table *, int,
    void *, size_t *, loff_t *);
extern int proc_dointvec(struct ctl_table *, int,
    void *, size_t *, loff_t *);
extern int proc_dointvec_minmax(struct ctl_table *, int,
    void *, size_t *, loff_t *);
extern int proc_dointvec_jiffies(struct ctl_table *, int,
     void *, size_t *, loff_t *);
extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int,
     void *, size_t *, loff_t *);
extern int proc_dointvec_ms_jiffies(struct ctl_table *, int,
        void *, size_t *, loff_t *);
extern int proc_doulongvec_minmax(struct ctl_table *, int,
      void *, size_t *, loff_t *);
extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
          void *, size_t *, loff_t *);
extern int proc_do_large_bitmap(struct ctl_table *, int,
    void *, size_t *, loff_t *);
# 89 "/usr/src/linux-2.6/include/linux/sysctl.h"
struct ctl_table_poll {
 atomic_t event;
 wait_queue_head_t wait;
};

static inline __attribute__((no_instrument_function)) void *proc_sys_poll_e=
vent(struct ctl_table_poll *poll)
{
 return (void *)(unsigned long)atomic_read(&poll->event);
}
# 107 "/usr/src/linux-2.6/include/linux/sysctl.h"
struct ctl_table
{
 const char *procname;
 void *data;
 int maxlen;
 umode_t mode;
 struct ctl_table *child;
 proc_handler *proc_handler;
 struct ctl_table_poll *poll;
 void *extra1;
 void *extra2;
};

struct ctl_node {
 struct rb_node node;
 struct ctl_table_header *header;
};



struct ctl_table_header
{
 union {
  struct {
   struct ctl_table *ctl_table;
   int used;
   int count;
   int nreg;
  };
  struct callback_head rcu;
 };
 struct completion *unregistering;
 struct ctl_table *ctl_table_arg;
 struct ctl_table_root *root;
 struct ctl_table_set *set;
 struct ctl_dir *parent;
 struct ctl_node *node;
};

struct ctl_dir {

 struct ctl_table_header header;
 struct rb_root root;
};

struct ctl_table_set {
 int (*is_seen)(struct ctl_table_set *);
 struct ctl_dir dir;
};

struct ctl_table_root {
 struct ctl_table_set default_set;
 struct ctl_table_set *(*lookup)(struct ctl_table_root *root,
        struct nsproxy *namespaces);
 int (*permissions)(struct ctl_table_header *head, struct ctl_table *table);
};


struct ctl_path {
 const char *procname;
};



void proc_sys_poll_notify(struct ctl_table_poll *poll);

extern void setup_sysctl_set(struct ctl_table_set *p,
 struct ctl_table_root *root,
 int (*is_seen)(struct ctl_table_set *));
extern void retire_sysctl_set(struct ctl_table_set *set);

void register_sysctl_root(struct ctl_table_root *root);
struct ctl_table_header *__register_sysctl_table(
 struct ctl_table_set *set,
 const char *path, struct ctl_table *table);
struct ctl_table_header *__register_sysctl_paths(
 struct ctl_table_set *set,
 const struct ctl_path *path, struct ctl_table *table);
struct ctl_table_header *register_sysctl(const char *path, struct ctl_table=
 *table);
struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
      struct ctl_table *table);

void unregister_sysctl_table(struct ctl_table_header * table);

extern int sysctl_init(void);
# 23 "/usr/src/linux-2.6/include/linux/key.h" 2







typedef int32_t key_serial_t;


typedef uint32_t key_perm_t;

struct key;
# 75 "/usr/src/linux-2.6/include/linux/key.h"
struct seq_file;
struct user_struct;
struct signal_struct;
struct cred;

struct key_type;
struct key_owner;
struct keyring_list;
struct keyring_name;
# 99 "/usr/src/linux-2.6/include/linux/key.h"
typedef struct __key_reference_with_attributes *key_ref_t;

static inline __attribute__((no_instrument_function)) key_ref_t make_key_re=
f(const struct key *key,
         unsigned long possession)
{
 return (key_ref_t) ((unsigned long) key | possession);
}

static inline __attribute__((no_instrument_function)) struct key *key_ref_t=
o_ptr(const key_ref_t key_ref)
{
 return (struct key *) ((unsigned long) key_ref & ~1UL);
}

static inline __attribute__((no_instrument_function)) unsigned long is_key_=
possessed(const key_ref_t key_ref)
{
 return (unsigned long) key_ref & 1UL;
}
# 125 "/usr/src/linux-2.6/include/linux/key.h"
struct key {
 atomic_t usage;
 key_serial_t serial;
 union {
  struct list_head graveyard_link;
  struct rb_node serial_node;
 };
 struct key_type *type;
 struct rw_semaphore sem;
 struct key_user *user;
 void *security;
 union {
  time_t expiry;
  time_t revoked_at;
 };
 time_t last_used_at;
 kuid_t uid;
 kgid_t gid;
 key_perm_t perm;
 unsigned short quotalen;
 unsigned short datalen;
# 156 "/usr/src/linux-2.6/include/linux/key.h"
 unsigned long flags;
# 171 "/usr/src/linux-2.6/include/linux/key.h"
 char *description;




 union {
  struct list_head link;
  unsigned long x[2];
  void *p[2];
  int reject_error;
 } type_data;





 union {
  unsigned long value;
  void *rcudata;
  void *data;
  struct keyring_list *subscriptions;
 } payload;
};

extern struct key *key_alloc(struct key_type *type,
        const char *desc,
        kuid_t uid, kgid_t gid,
        const struct cred *cred,
        key_perm_t perm,
        unsigned long flags);






extern void key_revoke(struct key *key);
extern void key_invalidate(struct key *key);
extern void key_put(struct key *key);

static inline __attribute__((no_instrument_function)) struct key *key_get(s=
truct key *key)
{
 if (key)
  atomic_inc(&key->usage);
 return key;
}

static inline __attribute__((no_instrument_function)) void key_ref_put(key_=
ref_t key_ref)
{
 key_put(key_ref_to_ptr(key_ref));
}

extern struct key *request_key(struct key_type *type,
          const char *description,
          const char *callout_info);

extern struct key *request_key_with_auxdata(struct key_type *type,
         const char *description,
         const void *callout_info,
         size_t callout_len,
         void *aux);

extern struct key *request_key_async(struct key_type *type,
         const char *description,
         const void *callout_info,
         size_t callout_len);

extern struct key *request_key_async_with_auxdata(struct key_type *type,
        const char *description,
        const void *callout_info,
        size_t callout_len,
        void *aux);

extern int wait_for_key_construction(struct key *key, bool intr);

extern int key_validate(const struct key *key);

extern key_ref_t key_create_or_update(key_ref_t keyring,
          const char *type,
          const char *description,
          const void *payload,
          size_t plen,
          key_perm_t perm,
          unsigned long flags);

extern int key_update(key_ref_t key,
        const void *payload,
        size_t plen);

extern int key_link(struct key *keyring,
      struct key *key);

extern int key_unlink(struct key *keyring,
        struct key *key);

extern struct key *keyring_alloc(const char *description, kuid_t uid, kgid_=
t gid,
     const struct cred *cred,
     key_perm_t perm,
     unsigned long flags,
     struct key *dest);

extern int keyring_clear(struct key *keyring);

extern key_ref_t keyring_search(key_ref_t keyring,
    struct key_type *type,
    const char *description);

extern int keyring_add_key(struct key *keyring,
      struct key *key);

extern struct key *key_lookup(key_serial_t id);

static inline __attribute__((no_instrument_function)) key_serial_t key_seri=
al(const struct key *key)
{
 return key ? key->serial : 0;
}

extern void key_set_timeout(struct key *, unsigned);
# 297 "/usr/src/linux-2.6/include/linux/key.h"
static inline __attribute__((no_instrument_function)) bool key_is_instantia=
ted(const struct key *key)
{
 return (__builtin_constant_p((0)) ? constant_test_bit((0), (&key->flags)) =
: variable_test_bit((0), (&key->flags))) &&
  !(__builtin_constant_p((5)) ? constant_test_bit((5), (&key->flags)) : var=
iable_test_bit((5), (&key->flags)));
}
# 313 "/usr/src/linux-2.6/include/linux/key.h"
extern ctl_table key_sysctls[];




extern int install_thread_keyring_to_cred(struct cred *cred);
extern void key_fsuid_changed(struct task_struct *tsk);
extern void key_fsgid_changed(struct task_struct *tsk);
extern void key_init(void);
# 18 "/usr/src/linux-2.6/include/linux/cred.h" 2
# 1 "/usr/src/linux-2.6/include/linux/selinux.h" 1
# 17 "/usr/src/linux-2.6/include/linux/selinux.h"
struct selinux_audit_rule;
struct audit_context;
struct kern_ipc_perm;






bool selinux_is_enabled(void);
# 19 "/usr/src/linux-2.6/include/linux/cred.h" 2



struct user_struct;
struct cred;
struct inode;







struct group_info {
 atomic_t usage;
 int ngroups;
 int nblocks;
 kgid_t small_block[32];
 kgid_t *blocks[0];
};
# 49 "/usr/src/linux-2.6/include/linux/cred.h"
static inline __attribute__((no_instrument_function)) struct group_info *ge=
t_group_info(struct group_info *gi)
{
 atomic_inc(&gi->usage);
 return gi;
}
# 65 "/usr/src/linux-2.6/include/linux/cred.h"
extern struct group_info *groups_alloc(int);
extern struct group_info init_groups;
extern void groups_free(struct group_info *);
extern int set_current_groups(struct group_info *);
extern int set_groups(struct cred *, struct group_info *);
extern int groups_search(const struct group_info *, kgid_t);





extern int in_group_p(kgid_t);
extern int in_egroup_p(kgid_t);
# 102 "/usr/src/linux-2.6/include/linux/cred.h"
struct cred {
 atomic_t usage;







 kuid_t uid;
 kgid_t gid;
 kuid_t suid;
 kgid_t sgid;
 kuid_t euid;
 kgid_t egid;
 kuid_t fsuid;
 kgid_t fsgid;
 unsigned securebits;
 kernel_cap_t cap_inheritable;
 kernel_cap_t cap_permitted;
 kernel_cap_t cap_effective;
 kernel_cap_t cap_bset;

 unsigned char jit_keyring;

 struct key *session_keyring;
 struct key *process_keyring;
 struct key *thread_keyring;
 struct key *request_key_auth;


 void *security;

 struct user_struct *user;
 struct user_namespace *user_ns;
 struct group_info *group_info;
 struct callback_head rcu;
};

extern void __put_cred(struct cred *);
extern void exit_creds(struct task_struct *);
extern int copy_creds(struct task_struct *, unsigned long);
extern const struct cred *get_task_cred(struct task_struct *);
extern struct cred *cred_alloc_blank(void);
extern struct cred *prepare_creds(void);
extern struct cred *prepare_exec_creds(void);
extern int commit_creds(struct cred *);
extern void abort_creds(struct cred *);
extern const struct cred *override_creds(const struct cred *);
extern void revert_creds(const struct cred *);
extern struct cred *prepare_kernel_cred(struct task_struct *);
extern int change_create_files_as(struct cred *, struct inode *);
extern int set_security_override(struct cred *, u32);
extern int set_security_override_from_ctx(struct cred *, const char *);
extern int set_create_files_as(struct cred *, struct inode *);
extern void __attribute__ ((__section__(".init.text"))) __attribute__((__co=
ld__)) __attribute__((no_instrument_function)) cred_init(void);
# 188 "/usr/src/linux-2.6/include/linux/cred.h"
static inline __attribute__((no_instrument_function)) void validate_creds(c=
onst struct cred *cred)
{
}
static inline __attribute__((no_instrument_function)) void validate_creds_f=
or_do_exit(struct task_struct *tsk)
{
}
static inline __attribute__((no_instrument_function)) void validate_process=
_creds(void)
{
}
# 206 "/usr/src/linux-2.6/include/linux/cred.h"
static inline __attribute__((no_instrument_function)) struct cred *get_new_=
cred(struct cred *cred)
{
 atomic_inc(&cred->usage);
 return cred;
}
# 225 "/usr/src/linux-2.6/include/linux/cred.h"
static inline __attribute__((no_instrument_function)) const struct cred *ge=
t_cred(const struct cred *cred)
{
 struct cred *nonconst_cred =3D (struct cred *) cred;
 validate_creds(cred);
 return get_new_cred(nonconst_cred);
}
# 243 "/usr/src/linux-2.6/include/linux/cred.h"
static inline __attribute__((no_instrument_function)) void put_cred(const s=
truct cred *_cred)
{
 struct cred *cred =3D (struct cred *) _cred;

 validate_creds(cred);
 if (atomic_dec_and_test(&(cred)->usage))
  __put_cred(cred);
}
# 343 "/usr/src/linux-2.6/include/linux/cred.h"
extern struct user_namespace init_user_ns;
# 53 "/usr/src/linux-2.6/include/linux/sched.h" 2
# 1 "/usr/src/linux-2.6/include/linux/llist.h" 1
# 61 "/usr/src/linux-2.6/include/linux/llist.h"
struct llist_head {
 struct llist_node *first;
};

struct llist_node {
 struct llist_node *next;
};
# 76 "/usr/src/linux-2.6/include/linux/llist.h"
static inline __attribute__((no_instrument_function)) void init_llist_head(=
struct llist_head *list)
{
 list->first =3D ((void *)0);
}
# 158 "/usr/src/linux-2.6/include/linux/llist.h"
static inline __attribute__((no_instrument_function)) bool llist_empty(cons=
t struct llist_head *head)
{
 return (*(volatile typeof(head->first) *)&(head->first)) =3D=3D ((void *)0=
);
}

static inline __attribute__((no_instrument_function)) struct llist_node *ll=
ist_next(struct llist_node *node)
{
 return node->next;
}

extern bool llist_add_batch(struct llist_node *new_first,
       struct llist_node *new_last,
       struct llist_head *head);







static inline __attribute__((no_instrument_function)) bool llist_add(struct=
 llist_node *new, struct llist_head *head)
{
 return llist_add_batch(new, new, head);
}
# 191 "/usr/src/linux-2.6/include/linux/llist.h"
static inline __attribute__((no_instrument_function)) struct llist_node *ll=
ist_del_all(struct llist_head *head)
{
 return ({ __typeof__ (*((&head->first))) __ret =3D ((((void *)0))); switch=
 (sizeof(*((&head->first)))) { case 1: asm volatile ("" "xchg" "b %b0, %1\n=
" : "+q" (__ret), "+m" (*((&head->first))) : : "memory", "cc"); break; case=
 2: asm volatile ("" "xchg" "w %w0, %1\n" : "+r" (__ret), "+m" (*((&head->f=
irst))) : : "memory", "cc"); break; case 4: asm volatile ("" "xchg" "l %0, =
%1\n" : "+r" (__ret), "+m" (*((&head->first))) : : "memory", "cc"); break; =
case -1: asm volatile ("" "xchg" "q %q0, %1\n" : "+r" (__ret), "+m" (*((&he=
ad->first))) : : "memory", "cc"); break; default: __xchg_wrong_size(); } __=
ret; });
}

extern struct llist_node *llist_del_first(struct llist_head *head);
# 54 "/usr/src/linux-2.6/include/linux/sched.h" 2

# 1 "/usr/src/linux-2.6/include/linux/gfp.h" 1







# 1 "/usr/src/linux-2.6/include/linux/mmdebug.h" 1
# 9 "/usr/src/linux-2.6/include/linux/gfp.h" 2

struct vm_area_struct;
# 157 "/usr/src/linux-2.6/include/linux/gfp.h"
static inline __attribute__((no_instrument_function)) int allocflags_to_mig=
ratetype(gfp_t gfp_flags)
{
 ({ int __ret_warn_on =3D !!((gfp_flags & ((( gfp_t)0x80000u)|(( gfp_t)0x08=
u))) =3D=3D ((( gfp_t)0x80000u)|(( gfp_t)0x08u))); if (__builtin_expect(!!(=
__ret_warn_on), 0)) warn_slowpath_null("/usr/src/linux-2.6/include/linux/gf=
p.h", 159); __builtin_expect(!!(__ret_warn_on), 0); });

 if (__builtin_expect(!!(page_group_by_mobility_disabled), 0))
  return MIGRATE_UNMOVABLE;


 return (((gfp_flags & (( gfp_t)0x08u)) !=3D 0) << 1) |
  ((gfp_flags & (( gfp_t)0x80000u)) !=3D 0);
}
# 252 "/usr/src/linux-2.6/include/linux/gfp.h"
static inline __attribute__((no_instrument_function)) enum zone_type gfp_zo=
ne(gfp_t flags)
{
 enum zone_type z;
 int bit =3D ( int) (flags & ((( gfp_t)0x01u)|(( gfp_t)0x02u)|(( gfp_t)0x04=
u)|(( gfp_t)0x08u)));

 z =3D (( (ZONE_NORMAL << 0 * 2) | (ZONE_DMA << 0x01u * 2) | (ZONE_HIGHMEM =
<< 0x02u * 2) | (ZONE_NORMAL << 0x04u * 2) | (ZONE_NORMAL << 0x08u * 2) | (=
ZONE_DMA << (0x08u | 0x01u) * 2) | (ZONE_MOVABLE << (0x08u | 0x02u) * 2) | =
(ZONE_NORMAL << (0x08u | 0x04u) * 2) ) >> (bit * 2)) &
      ((1 << 2) - 1);
 ((void)(sizeof(( long)((( 1 << (0x01u | 0x02u) | 1 << (0x01u | 0x04u) | 1 =
<< (0x04u | 0x02u) | 1 << (0x01u | 0x04u | 0x02u) | 1 << (0x08u | 0x02u | 0=
x01u) | 1 << (0x08u | 0x04u | 0x01u) | 1 << (0x08u | 0x04u | 0x02u) | 1 << =
(0x08u | 0x04u | 0x01u | 0x02u) ) >> bit) & 1))));
 return z;
}
# 270 "/usr/src/linux-2.6/include/linux/gfp.h"
static inline __attribute__((no_instrument_function)) int gfp_zonelist(gfp_=
t flags)
{
 if ((0 || 0) && __builtin_expect(!!(flags & (( gfp_t)0x40000u)), 0))
  return 1;

 return 0;
}
# 287 "/usr/src/linux-2.6/include/linux/gfp.h"
static inline __attribute__((no_instrument_function)) struct zonelist *node=
_zonelist(int nid, gfp_t flags)
{
 return (&contig_page_data)->node_zonelists + gfp_zonelist(flags);
}


static inline __attribute__((no_instrument_function)) void arch_free_page(s=
truct page *page, int order) { }


static inline __attribute__((no_instrument_function)) void arch_alloc_page(=
struct page *page, int order) { }


struct page *
__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
         struct zonelist *zonelist, nodemask_t *nodemask);

static inline __attribute__((no_instrument_function)) struct page *
__alloc_pages(gfp_t gfp_mask, unsigned int order,
  struct zonelist *zonelist)
{
 return __alloc_pages_nodemask(gfp_mask, order, zonelist, ((void *)0));
}

static inline __attribute__((no_instrument_function)) struct page *alloc_pa=
ges_node(int nid, gfp_t gfp_mask,
      unsigned int order)
{

 if (nid < 0)
  nid =3D numa_node_id();

 return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
}

static inline __attribute__((no_instrument_function)) struct page *alloc_pa=
ges_exact_node(int nid, gfp_t gfp_mask,
      unsigned int order)
{
 ((void)(sizeof(( long)(nid < 0 || nid >=3D (1 << 0) || !node_state((nid), =
N_ONLINE)))));

 return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
}
# 351 "/usr/src/linux-2.6/include/linux/gfp.h"
extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
extern unsigned long get_zeroed_page(gfp_t gfp_mask);

void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
void free_pages_exact(void *virt, size_t size);

void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);







extern void __free_pages(struct page *page, unsigned int order);
extern void free_pages(unsigned long addr, unsigned int order);
extern void free_hot_cold_page(struct page *page, int cold);
extern void free_hot_cold_page_list(struct list_head *list, int cold);

extern void __free_memcg_kmem_pages(struct page *page, unsigned int order);
extern void free_memcg_kmem_pages(unsigned long addr, unsigned int order);




void page_alloc_init(void);
void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
void drain_all_pages(void);
void drain_local_pages(void *dummy);
# 388 "/usr/src/linux-2.6/include/linux/gfp.h"
extern gfp_t gfp_allowed_mask;


bool gfp_pfmemalloc_allowed(gfp_t gfp_mask);

extern void pm_restrict_gfp_mask(void);
extern void pm_restore_gfp_mask(void);


extern bool pm_suspended_storage(void);
# 56 "/usr/src/linux-2.6/include/linux/sched.h" 2



struct exec_domain;
struct futex_pi_state;
struct robust_list_head;
struct bio_list;
struct fs_struct;
struct perf_event_context;
struct blk_plug;
# 83 "/usr/src/linux-2.6/include/linux/sched.h"
extern unsigned long avenrun[];
extern void get_avenrun(unsigned long *loads, unsigned long offset, int shi=
ft);
# 98 "/usr/src/linux-2.6/include/linux/sched.h"
extern unsigned long total_forks;
extern int nr_threads;
extern __attribute__((section(".data" ""))) __typeof__(unsigned long) proce=
ss_counts;
extern int nr_processes(void);
extern unsigned long nr_running(void);
extern unsigned long nr_iowait(void);
extern unsigned long nr_iowait_cpu(int cpu);
extern unsigned long this_cpu_load(void);


extern void calc_global_load(unsigned long ticks);
extern void update_cpu_load_nohz(void);

extern unsigned long get_parent_ip(unsigned long addr);

extern void dump_cpu_task(int cpu);

struct seq_file;
struct cfs_rq;
struct task_group;
# 152 "/usr/src/linux-2.6/include/linux/sched.h"
extern char ___assert_task_state[1 - 2*!!(
  sizeof("RSDTtZXxKWP")-1 !=3D ( __builtin_constant_p(1024) ? ( (1024) < 1 =
? ____ilog2_NaN() : (1024) & (1ULL << 63) ? 63 : (1024) & (1ULL << 62) ? 62=
 : (1024) & (1ULL << 61) ? 61 : (1024) & (1ULL << 60) ? 60 : (1024) & (1ULL=
 << 59) ? 59 : (1024) & (1ULL << 58) ? 58 : (1024) & (1ULL << 57) ? 57 : (1=
024) & (1ULL << 56) ? 56 : (1024) & (1ULL << 55) ? 55 : (1024) & (1ULL << 5=
4) ? 54 : (1024) & (1ULL << 53) ? 53 : (1024) & (1ULL << 52) ? 52 : (1024) =
& (1ULL << 51) ? 51 : (1024) & (1ULL << 50) ? 50 : (1024) & (1ULL << 49) ? =
49 : (1024) & (1ULL << 48) ? 48 : (1024) & (1ULL << 47) ? 47 : (1024) & (1U=
LL << 46) ? 46 : (1024) & (1ULL << 45) ? 45 : (1024) & (1ULL << 44) ? 44 : =
(1024) & (1ULL << 43) ? 43 : (1024) & (1ULL << 42) ? 42 : (1024) & (1ULL <<=
 41) ? 41 : (1024) & (1ULL << 40) ? 40 : (1024) & (1ULL << 39) ? 39 : (1024=
) & (1ULL << 38) ? 38 : (1024) & (1ULL << 37) ? 37 : (1024) & (1ULL << 36) =
? 36 : (1024) & (1ULL << 35) ? 35 : (1024) & (1ULL << 34) ? 34 : (1024) & (=
1ULL << 33) ? 33 : (1024) & (1ULL << 32) ? 32 : (1024) & (1ULL << 31) ? 31 =
: (1024) & (1ULL << 30) ? 30 : (1024) & (1ULL << 29) ? 29 : (1024) & (1ULL =
<< 28) ? 28 : (1024) & (1ULL << 27) ? 27 : (1024) & (1ULL << 26) ? 26 : (10=
24) & (1ULL << 25) ? 25 : (1024) & (1ULL << 24) ? 24 : (1024) & (1ULL << 23=
) ? 23 : (1024) & (1ULL << 22) ? 22 : (1024) & (1ULL << 21) ? 21 : (1024) &=
 (1ULL << 20) ? 20 : (1024) & (1ULL << 19) ? 19 : (1024) & (1ULL << 18) ? 1=
8 : (1024) & (1ULL << 17) ? 17 : (1024) & (1ULL << 16) ? 16 : (1024) & (1UL=
L << 15) ? 15 : (1024) & (1ULL << 14) ? 14 : (1024) & (1ULL << 13) ? 13 : (=
1024) & (1ULL << 12) ? 12 : (1024) & (1ULL << 11) ? 11 : (1024) & (1ULL << =
10) ? 10 : (1024) & (1ULL << 9) ? 9 : (1024) & (1ULL << 8) ? 8 : (1024) & (=
1ULL << 7) ? 7 : (1024) & (1ULL << 6) ? 6 : (1024) & (1ULL << 5) ? 5 : (102=
4) & (1ULL << 4) ? 4 : (1024) & (1ULL << 3) ? 3 : (1024) & (1ULL << 2) ? 2 =
: (1024) & (1ULL << 1) ? 1 : (1024) & (1ULL << 0) ? 0 : ____ilog2_NaN() ) :=
 (sizeof(1024) <=3D 4) ? __ilog2_u32(1024) : __ilog2_u64(1024) )+1)];
# 210 "/usr/src/linux-2.6/include/linux/sched.h"
extern rwlock_t tasklist_lock;
extern spinlock_t mmlist_lock;

struct task_struct;





extern void sched_init(void);
extern void sched_init_smp(void);
extern __attribute__((regparm(0))) void schedule_tail(struct task_struct *p=
rev);
extern void init_idle(struct task_struct *idle, int cpu);
extern void init_idle_bootup_task(struct task_struct *idle);

extern int runqueue_is_locked(int cpu);






static inline __attribute__((no_instrument_function)) void nohz_balance_ent=
er_idle(int cpu) { }
static inline __attribute__((no_instrument_function)) void set_cpu_sd_state=
_idle(void) { }





extern void show_state_filter(unsigned long state_filter);

static inline __attribute__((no_instrument_function)) void show_state(void)
{
 show_state_filter(0);
}

extern void show_regs(struct pt_regs *);






extern void show_stack(struct task_struct *task, unsigned long *sp);

void io_schedule(void);
long io_schedule_timeout(long timeout);

extern void cpu_init (void);
extern void trap_init(void);
extern void update_process_times(int user);
extern void scheduler_tick(void);

extern void sched_show_task(struct task_struct *p);
# 275 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void touch_softlockup=
_watchdog(void)
{
}
static inline __attribute__((no_instrument_function)) void touch_softlockup=
_watchdog_sync(void)
{
}
static inline __attribute__((no_instrument_function)) void touch_all_softlo=
ckup_watchdogs(void)
{
}
static inline __attribute__((no_instrument_function)) void lockup_detector_=
init(void)
{
}






extern char __sched_text_start[], __sched_text_end[];


extern int in_sched_functions(unsigned long addr);


extern signed long schedule_timeout(signed long timeout);
extern signed long schedule_timeout_interruptible(signed long timeout);
extern signed long schedule_timeout_killable(signed long timeout);
extern signed long schedule_timeout_uninterruptible(signed long timeout);
 __attribute__((regparm(0))) void schedule(void);
extern void schedule_preempt_disabled(void);

struct nsproxy;
struct user_namespace;


extern void arch_pick_mmap_layout(struct mm_struct *mm);
extern unsigned long
arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
         unsigned long, unsigned long);
extern unsigned long
arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
     unsigned long len, unsigned long pgoff,
     unsigned long flags);





extern void set_dumpable(struct mm_struct *mm, int value);
extern int get_dumpable(struct mm_struct *mm);
# 366 "/usr/src/linux-2.6/include/linux/sched.h"
struct sighand_struct {
 atomic_t count;
 struct k_sigaction action[64];
 spinlock_t siglock;
 wait_queue_head_t signalfd_wqh;
};

struct pacct_struct {
 int ac_flag;
 long ac_exitcode;
 unsigned long ac_mem;
 cputime_t ac_utime, ac_stime;
 unsigned long ac_minflt, ac_majflt;
};

struct cpu_itimer {
 cputime_t expires;
 cputime_t incr;
 u32 error;
 u32 incr_error;
};
# 395 "/usr/src/linux-2.6/include/linux/sched.h"
struct cputime {
 cputime_t utime;
 cputime_t stime;
};
# 414 "/usr/src/linux-2.6/include/linux/sched.h"
struct task_cputime {
 cputime_t utime;
 cputime_t stime;
 unsigned long long sum_exec_runtime;
};
# 458 "/usr/src/linux-2.6/include/linux/sched.h"
struct thread_group_cputimer {
 struct task_cputime cputime;
 int running;
 raw_spinlock_t lock;
};


struct autogroup;
# 474 "/usr/src/linux-2.6/include/linux/sched.h"
struct signal_struct {
 atomic_t sigcnt;
 atomic_t live;
 int nr_threads;

 wait_queue_head_t wait_chldexit;


 struct task_struct *curr_target;


 struct sigpending shared_pending;


 int group_exit_code;





 int notify_count;
 struct task_struct *group_exit_task;


 int group_stop_count;
 unsigned int flags;
# 510 "/usr/src/linux-2.6/include/linux/sched.h"
 unsigned int is_child_subreaper:1;
 unsigned int has_child_subreaper:1;


 int posix_timer_id;
 struct list_head posix_timers;


 struct hrtimer real_timer;
 struct pid *leader_pid;
 ktime_t it_real_incr;






 struct cpu_itimer it[2];





 struct thread_group_cputimer cputimer;


 struct task_cputime cputime_expires;

 struct list_head cpu_timers[3];

 struct pid *tty_old_pgrp;


 int leader;

 struct tty_struct *tty;
# 556 "/usr/src/linux-2.6/include/linux/sched.h"
 cputime_t utime, stime, cutime, cstime;
 cputime_t gtime;
 cputime_t cgtime;

 struct cputime prev_cputime;

 unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 unsigned long inblock, oublock, cinblock, coublock;
 unsigned long maxrss, cmaxrss;
 struct task_io_accounting ioac;







 unsigned long long sum_sched_runtime;
# 585 "/usr/src/linux-2.6/include/linux/sched.h"
 struct rlimit rlim[16];


 struct pacct_struct pacct;


 struct taskstats *stats;


 unsigned audit_tty;
 unsigned audit_tty_log_passwd;
 struct tty_audit_buf *tty_audit_buf;
# 608 "/usr/src/linux-2.6/include/linux/sched.h"
 struct rw_semaphore group_rwsem;


 oom_flags_t oom_flags;
 short oom_score_adj;
 short oom_score_adj_min;


 struct mutex cred_guard_mutex;


};
# 638 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) int signal_group_exit=
(const struct signal_struct *sig)
{
 return (sig->flags & 0x00000004) ||
  (sig->group_exit_task !=3D ((void *)0));
}




struct user_struct {
 atomic_t __count;
 atomic_t processes;
 atomic_t files;
 atomic_t sigpending;

 atomic_t inotify_watches;
 atomic_t inotify_devs;





 atomic_long_t epoll_watches;



 unsigned long mq_bytes;

 unsigned long locked_shm;


 struct key *uid_keyring;
 struct key *session_keyring;



 struct hlist_node uidhash_node;
 kuid_t uid;


 atomic_long_t locked_vm;

};

extern int uids_sysfs_init(void);

extern struct user_struct *find_user(kuid_t);

extern struct user_struct root_user;



struct backing_dev_info;
struct reclaim_state;


struct sched_info {

 unsigned long pcount;
 unsigned long long run_delay;


 unsigned long long last_arrival,
      last_queued;
};



struct task_delay_info {
 spinlock_t lock;
 unsigned int flags;
# 725 "/usr/src/linux-2.6/include/linux/sched.h"
 struct timespec blkio_start, blkio_end;
 u64 blkio_delay;
 u64 swapin_delay;
 u32 blkio_count;

 u32 swapin_count;


 struct timespec freepages_start, freepages_end;
 u64 freepages_delay;
 u32 freepages_count;
};


static inline __attribute__((no_instrument_function)) int sched_info_on(voi=
d)
{

 return 1;






}

enum cpu_idle_type {
 CPU_IDLE,
 CPU_NOT_IDLE,
 CPU_NEWLY_IDLE,
 CPU_MAX_IDLE_TYPES
};
# 893 "/usr/src/linux-2.6/include/linux/sched.h"
struct sched_domain_attr;

static inline __attribute__((no_instrument_function)) void
partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
   struct sched_domain_attr *dattr_new)
{
}

static inline __attribute__((no_instrument_function)) bool cpus_share_cache=
(int this_cpu, int that_cpu)
{
 return true;
}




struct io_context;





static inline __attribute__((no_instrument_function)) void prefetch_stack(s=
truct task_struct *t) { }


struct audit_context;
struct mempolicy;
struct pipe_inode_info;
struct uts_namespace;

struct load_weight {
 unsigned long weight, inv_weight;
};

struct sched_avg {





 u32 runnable_avg_sum, runnable_avg_period;
 u64 last_runnable_update;
 s64 decay_count;
 unsigned long load_avg_contrib;
};


struct sched_statistics {
 u64 wait_start;
 u64 wait_max;
 u64 wait_count;
 u64 wait_sum;
 u64 iowait_count;
 u64 iowait_sum;

 u64 sleep_start;
 u64 sleep_max;
 s64 sum_sleep_runtime;

 u64 block_start;
 u64 block_max;
 u64 exec_max;
 u64 slice_max;

 u64 nr_migrations_cold;
 u64 nr_failed_migrations_affine;
 u64 nr_failed_migrations_running;
 u64 nr_failed_migrations_hot;
 u64 nr_forced_migrations;

 u64 nr_wakeups;
 u64 nr_wakeups_sync;
 u64 nr_wakeups_migrate;
 u64 nr_wakeups_local;
 u64 nr_wakeups_remote;
 u64 nr_wakeups_affine;
 u64 nr_wakeups_affine_attempts;
 u64 nr_wakeups_passive;
 u64 nr_wakeups_idle;
};


struct sched_entity {
 struct load_weight load;
 struct rb_node run_node;
 struct list_head group_node;
 unsigned int on_rq;

 u64 exec_start;
 u64 sum_exec_runtime;
 u64 vruntime;
 u64 prev_sum_exec_runtime;

 u64 nr_migrations;


 struct sched_statistics statistics;



 struct sched_entity *parent;

 struct cfs_rq *cfs_rq;

 struct cfs_rq *my_q;






};

struct sched_rt_entity {
 struct list_head run_list;
 unsigned long timeout;
 unsigned long watchdog_stamp;
 unsigned int time_slice;

 struct sched_rt_entity *back;







};


struct rcu_node;

enum perf_event_task_context {
 perf_invalid_context =3D -1,
 perf_hw_context =3D 0,
 perf_sw_context,
 perf_nr_task_contexts,
};

struct task_struct {
 volatile long state;
 void *stack;
 atomic_t usage;
 unsigned int flags;
 unsigned int ptrace;
# 1046 "/usr/src/linux-2.6/include/linux/sched.h"
 int on_rq;

 int prio, static_prio, normal_prio;
 unsigned int rt_priority;
 const struct sched_class *sched_class;
 struct sched_entity se;
 struct sched_rt_entity rt;

 struct task_group *sched_task_group;
# 1070 "/usr/src/linux-2.6/include/linux/sched.h"
 unsigned char fpu_counter;

 unsigned int btrace_seq;


 unsigned int policy;
 int nr_cpus_allowed;
 cpumask_t cpus_allowed;
# 1092 "/usr/src/linux-2.6/include/linux/sched.h"
 struct sched_info sched_info;


 struct list_head tasks;




 struct mm_struct *mm, *active_mm;







 int exit_state;
 int exit_code, exit_signal;
 int pdeath_signal;
 unsigned int jobctl;


 unsigned int personality;

 unsigned did_exec:1;
 unsigned in_execve:1;

 unsigned in_iowait:1;


 unsigned no_new_privs:1;


 unsigned sched_reset_on_fork:1;
 unsigned sched_contributes_to_load:1;

 pid_t pid;
 pid_t tgid;
# 1140 "/usr/src/linux-2.6/include/linux/sched.h"
 struct task_struct *real_parent;
 struct task_struct *parent;



 struct list_head children;
 struct list_head sibling;
 struct task_struct *group_leader;






 struct list_head ptraced;
 struct list_head ptrace_entry;


 struct pid_link pids[PIDTYPE_MAX];
 struct list_head thread_group;

 struct completion *vfork_done;
 int *set_child_tid;
 int *clear_child_tid;

 cputime_t utime, stime, utimescaled, stimescaled;
 cputime_t gtime;

 struct cputime prev_cputime;
# 1179 "/usr/src/linux-2.6/include/linux/sched.h"
 unsigned long nvcsw, nivcsw;
 struct timespec start_time;
 struct timespec real_start_time;

 unsigned long min_flt, maj_flt;

 struct task_cputime cputime_expires;
 struct list_head cpu_timers[3];


 const struct cred *real_cred;

 const struct cred *cred;

 char comm[16];




 int link_count, total_link_count;


 struct sysv_sem sysvsem;






 struct thread_struct thread;

 struct fs_struct *fs;

 struct files_struct *files;

 struct nsproxy *nsproxy;

 struct signal_struct *signal;
 struct sighand_struct *sighand;

 sigset_t blocked, real_blocked;
 sigset_t saved_sigmask;
 struct sigpending pending;

 unsigned long sas_ss_sp;
 size_t sas_ss_size;
 int (*notifier)(void *priv);
 void *notifier_data;
 sigset_t *notifier_mask;
 struct callback_head *task_works;

 struct audit_context *audit_context;

 kuid_t loginuid;
 unsigned int sessionid;

 struct seccomp seccomp;


    u32 parent_exec_id;
    u32 self_exec_id;


 spinlock_t alloc_lock;


 raw_spinlock_t pi_lock;



 struct plist_head pi_waiters;

 struct rt_mutex_waiter *pi_blocked_on;
# 1283 "/usr/src/linux-2.6/include/linux/sched.h"
 void *journal_info;


 struct bio_list *bio_list;



 struct blk_plug *plug;



 struct reclaim_state *reclaim_state;

 struct backing_dev_info *backing_dev_info;

 struct io_context *io_context;

 unsigned long ptrace_message;
 siginfo_t *last_siginfo;
 struct task_io_accounting ioac;

 u64 acct_rss_mem1;
 u64 acct_vm_mem1;
 cputime_t acct_timexpd;


 nodemask_t mems_allowed;
 seqcount_t mems_allowed_seq;
 int cpuset_mem_spread_rotor;
 int cpuset_slab_spread_rotor;



 struct css_set *cgroups;

 struct list_head cg_list;


 struct robust_list_head *robust_list;



 struct list_head pi_state_list;
 struct futex_pi_state *pi_state_cache;


 struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
 struct mutex perf_event_mutex;
 struct list_head perf_event_list;
# 1346 "/usr/src/linux-2.6/include/linux/sched.h"
 struct callback_head rcu;




 struct pipe_inode_info *splice_pipe;

 struct page_frag task_frag;


 struct task_delay_info *delays;
# 1365 "/usr/src/linux-2.6/include/linux/sched.h"
 int nr_dirtied;
 int nr_dirtied_pause;
 unsigned long dirty_paused_when;
# 1377 "/usr/src/linux-2.6/include/linux/sched.h"
 unsigned long timer_slack_ns;
 unsigned long default_timer_slack_ns;
# 1397 "/usr/src/linux-2.6/include/linux/sched.h"
 unsigned long trace;

 unsigned long trace_recursion;
# 1424 "/usr/src/linux-2.6/include/linux/sched.h"
};
# 1433 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void task_numa_fault(=
int node, int pages, bool migrated)
{
}
static inline __attribute__((no_instrument_function)) void set_numabalancin=
g_state(bool enabled)
{
}


static inline __attribute__((no_instrument_function)) struct pid *task_pid(=
struct task_struct *task)
{
 return task->pids[PIDTYPE_PID].pid;
}

static inline __attribute__((no_instrument_function)) struct pid *task_tgid=
(struct task_struct *task)
{
 return task->group_leader->pids[PIDTYPE_PID].pid;
}






static inline __attribute__((no_instrument_function)) struct pid *task_pgrp=
(struct task_struct *task)
{
 return task->group_leader->pids[PIDTYPE_PGID].pid;
}

static inline __attribute__((no_instrument_function)) struct pid *task_sess=
ion(struct task_struct *task)
{
 return task->group_leader->pids[PIDTYPE_SID].pid;
}

struct pid_namespace;
# 1481 "/usr/src/linux-2.6/include/linux/sched.h"
pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
   struct pid_namespace *ns);

static inline __attribute__((no_instrument_function)) pid_t task_pid_nr(str=
uct task_struct *tsk)
{
 return tsk->pid;
}

static inline __attribute__((no_instrument_function)) pid_t task_pid_nr_ns(=
struct task_struct *tsk,
     struct pid_namespace *ns)
{
 return __task_pid_nr_ns(tsk, PIDTYPE_PID, ns);
}

static inline __attribute__((no_instrument_function)) pid_t task_pid_vnr(st=
ruct task_struct *tsk)
{
 return __task_pid_nr_ns(tsk, PIDTYPE_PID, ((void *)0));
}


static inline __attribute__((no_instrument_function)) pid_t task_tgid_nr(st=
ruct task_struct *tsk)
{
 return tsk->tgid;
}

pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);

static inline __attribute__((no_instrument_function)) pid_t task_tgid_vnr(s=
truct task_struct *tsk)
{
 return pid_vnr(task_tgid(tsk));
}


static inline __attribute__((no_instrument_function)) pid_t task_pgrp_nr_ns=
(struct task_struct *tsk,
     struct pid_namespace *ns)
{
 return __task_pid_nr_ns(tsk, PIDTYPE_PGID, ns);
}

static inline __attribute__((no_instrument_function)) pid_t task_pgrp_vnr(s=
truct task_struct *tsk)
{
 return __task_pid_nr_ns(tsk, PIDTYPE_PGID, ((void *)0));
}


static inline __attribute__((no_instrument_function)) pid_t task_session_nr=
_ns(struct task_struct *tsk,
     struct pid_namespace *ns)
{
 return __task_pid_nr_ns(tsk, PIDTYPE_SID, ns);
}

static inline __attribute__((no_instrument_function)) pid_t task_session_vn=
r(struct task_struct *tsk)
{
 return __task_pid_nr_ns(tsk, PIDTYPE_SID, ((void *)0));
}


static inline __attribute__((no_instrument_function)) pid_t task_pgrp_nr(st=
ruct task_struct *tsk)
{
 return task_pgrp_nr_ns(tsk, &init_pid_ns);
}
# 1553 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) int pid_alive(struct =
task_struct *p)
{
 return p->pids[PIDTYPE_PID].pid !=3D ((void *)0);
}
# 1566 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) int is_global_init(st=
ruct task_struct *tsk)
{
 return tsk->pid =3D=3D 1;
}

extern struct pid *cad_pid;

extern void free_task(struct task_struct *tsk);


extern void __put_task_struct(struct task_struct *t);

static inline __attribute__((no_instrument_function)) void put_task_struct(=
struct task_struct *t)
{
 if (atomic_dec_and_test(&t->usage))
  __put_task_struct(t);
}
# 1591 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void task_cputime(str=
uct task_struct *t,
    cputime_t *utime, cputime_t *stime)
{
 if (utime)
  *utime =3D t->utime;
 if (stime)
  *stime =3D t->stime;
}

static inline __attribute__((no_instrument_function)) void task_cputime_sca=
led(struct task_struct *t,
           cputime_t *utimescaled,
           cputime_t *stimescaled)
{
 if (utimescaled)
  *utimescaled =3D t->utimescaled;
 if (stimescaled)
  *stimescaled =3D t->stimescaled;
}

static inline __attribute__((no_instrument_function)) cputime_t task_gtime(=
struct task_struct *t)
{
 return t->gtime;
}

extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cpu=
time_t *st);
extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t =
*ut, cputime_t *st);
# 1678 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) gfp_t memalloc_noio_f=
lags(gfp_t flags)
{
 if (__builtin_expect(!!(get_current()->flags & 0x00080000), 0))
  flags &=3D ~(( gfp_t)0x40u);
 return flags;
}

static inline __attribute__((no_instrument_function)) unsigned int memalloc=
_noio_save(void)
{
 unsigned int flags =3D get_current()->flags & 0x00080000;
 get_current()->flags |=3D 0x00080000;
 return flags;
}

static inline __attribute__((no_instrument_function)) void memalloc_noio_re=
store(unsigned int flags)
{
 get_current()->flags =3D (get_current()->flags & ~0x00080000) | flags;
}
# 1721 "/usr/src/linux-2.6/include/linux/sched.h"
extern bool task_set_jobctl_pending(struct task_struct *task,
        unsigned int mask);
extern void task_clear_jobctl_trapping(struct task_struct *task);
extern void task_clear_jobctl_pending(struct task_struct *task,
          unsigned int mask);
# 1747 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void rcu_copy_process=
(struct task_struct *p)
{
}



static inline __attribute__((no_instrument_function)) void tsk_restore_flag=
s(struct task_struct *task,
    unsigned long orig_flags, unsigned long flags)
{
 task->flags &=3D ~flags;
 task->flags |=3D orig_flags & flags;
}
# 1767 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void do_set_cpus_allo=
wed(struct task_struct *p,
          const struct cpumask *new_mask)
{
}
static inline __attribute__((no_instrument_function)) int set_cpus_allowed_=
ptr(struct task_struct *p,
           const struct cpumask *new_mask)
{
 if (!(__builtin_constant_p((cpumask_check(0))) ? constant_test_bit((cpumas=
k_check(0)), ((((new_mask))->bits))) : variable_test_bit((cpumask_check(0))=
, ((((new_mask))->bits)))))
  return -22;
 return 0;
}



void calc_load_enter_idle(void);
void calc_load_exit_idle(void);






static inline __attribute__((no_instrument_function)) int set_cpus_allowed(=
struct task_struct *p, cpumask_t new_mask)
{
 return set_cpus_allowed_ptr(p, &new_mask);
}
# 1803 "/usr/src/linux-2.6/include/linux/sched.h"
extern unsigned long long __attribute__((no_instrument_function)) sched_clo=
ck(void);



extern u64 cpu_clock(int cpu);
extern u64 local_clock(void);
extern u64 sched_clock_cpu(int cpu);


extern void sched_clock_init(void);
# 1833 "/usr/src/linux-2.6/include/linux/sched.h"
extern int sched_clock_stable;

extern void sched_clock_tick(void);
extern void sched_clock_idle_sleep_event(void);
extern void sched_clock_idle_wakeup_event(u64 delta_ns);
# 1849 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void enable_sched_clo=
ck_irqtime(void) {}
static inline __attribute__((no_instrument_function)) void disable_sched_cl=
ock_irqtime(void) {}


extern unsigned long long
task_sched_runtime(struct task_struct *task);
# 1863 "/usr/src/linux-2.6/include/linux/sched.h"
extern void sched_clock_idle_sleep_event(void);
extern void sched_clock_idle_wakeup_event(u64 delta_ns);




static inline __attribute__((no_instrument_function)) void idle_task_exit(v=
oid) {}





static inline __attribute__((no_instrument_function)) void wake_up_nohz_cpu=
(int cpu) { }






static inline __attribute__((no_instrument_function)) bool sched_can_stop_t=
ick(void) { return false; }
# 1895 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void sched_autogroup_=
create_attach(struct task_struct *p) { }
static inline __attribute__((no_instrument_function)) void sched_autogroup_=
detach(struct task_struct *p) { }
static inline __attribute__((no_instrument_function)) void sched_autogroup_=
fork(struct signal_struct *sig) { }
static inline __attribute__((no_instrument_function)) void sched_autogroup_=
exit(struct signal_struct *sig) { }


extern bool yield_to(struct task_struct *p, bool preempt);
extern void set_user_nice(struct task_struct *p, long nice);
extern int task_prio(const struct task_struct *p);
extern int task_nice(const struct task_struct *p);
extern int can_nice(const struct task_struct *p, const int nice);
extern int task_curr(const struct task_struct *p);
extern int idle_cpu(int cpu);
extern int sched_setscheduler(struct task_struct *, int,
         const struct sched_param *);
extern int sched_setscheduler_nocheck(struct task_struct *, int,
          const struct sched_param *);
extern struct task_struct *idle_task(int cpu);






static inline __attribute__((no_instrument_function)) bool is_idle_task(con=
st struct task_struct *p)
{
 return p->pid =3D=3D 0;
}
extern struct task_struct *curr_task(int cpu);
extern void set_curr_task(int cpu, struct task_struct *p);

void yield(void);




extern struct exec_domain default_exec_domain;

union thread_union {
 struct thread_info thread_info;
 unsigned long stack[(((1UL) << 12) << 1)/sizeof(long)];
};


static inline __attribute__((no_instrument_function)) int kstack_end(void *=
addr)
{



 return !(((unsigned long)addr+sizeof(void*)-1) & ((((1UL) << 12) << 1)-siz=
eof(void*)));
}


extern union thread_union init_thread_union;
extern struct task_struct init_task;

extern struct mm_struct init_mm;

extern struct pid_namespace init_pid_ns;
# 1966 "/usr/src/linux-2.6/include/linux/sched.h"
extern struct task_struct *find_task_by_vpid(pid_t nr);
extern struct task_struct *find_task_by_pid_ns(pid_t nr,
  struct pid_namespace *ns);


extern struct user_struct * alloc_uid(kuid_t);
static inline __attribute__((no_instrument_function)) struct user_struct *g=
et_uid(struct user_struct *u)
{
 atomic_inc(&u->__count);
 return u;
}
extern void free_uid(struct user_struct *);



extern void xtime_update(unsigned long ticks);

extern int wake_up_state(struct task_struct *tsk, unsigned int state);
extern int wake_up_process(struct task_struct *tsk);
extern void wake_up_new_task(struct task_struct *tsk);



 static inline __attribute__((no_instrument_function)) void kick_process(st=
ruct task_struct *tsk) { }

extern void sched_fork(struct task_struct *p);
extern void sched_dead(struct task_struct *p);

extern void proc_caches_init(void);
extern void flush_signals(struct task_struct *);
extern void __flush_signals(struct task_struct *);
extern void ignore_signals(struct task_struct *);
extern void flush_signal_handlers(struct task_struct *, int force_default);
extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_=
t *info);

static inline __attribute__((no_instrument_function)) int dequeue_signal_lo=
ck(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
{
 unsigned long flags;
 int ret;

 do { do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dumm=
y =3D=3D &__dummy2); 1; }); do { do { do { ({ unsigned long __dummy; typeof=
(flags) __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); flags =3D arch_=
local_irq_save(); } while (0); do { } while (0); } while (0); do { __asm__ =
__volatile__("": : :"memory"); (void)0; (void)(spinlock_check(&tsk->sighand=
->siglock)); } while (0); } while (0); } while (0); } while (0);
 ret =3D dequeue_signal(tsk, mask, info);
 spin_unlock_irqrestore(&tsk->sighand->siglock, flags);

 return ret;
}

extern void block_all_signals(int (*notifier)(void *priv), void *priv,
         sigset_t *mask);
extern void unblock_all_signals(void);
extern void release_task(struct task_struct * p);
extern int send_sig_info(int, struct siginfo *, struct task_struct *);
extern int force_sigsegv(int, struct task_struct *);
extern int force_sig_info(int, struct siginfo *, struct task_struct *);
extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp=
);
extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
extern int kill_pid_info_as_cred(int, struct siginfo *, struct pid *,
    const struct cred *, u32);
extern int kill_pgrp(struct pid *pid, int sig, int priv);
extern int kill_pid(struct pid *pid, int sig, int priv);
extern int kill_proc_info(int, struct siginfo *, pid_t);
extern __attribute__((warn_unused_result)) bool do_notify_parent(struct tas=
k_struct *, int);
extern void __wake_up_parent(struct task_struct *p, struct task_struct *par=
ent);
extern void force_sig(int, struct task_struct *);
extern int send_sig(int, struct task_struct *, int);
extern int zap_other_threads(struct task_struct *p);
extern struct sigqueue *sigqueue_alloc(void);
extern void sigqueue_free(struct sigqueue *);
extern int send_sigqueue(struct sigqueue *, struct task_struct *, int group=
);
extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);

static inline __attribute__((no_instrument_function)) void restore_saved_si=
gmask(void)
{
 if (test_and_clear_restore_sigmask())
  __set_current_blocked(&get_current()->saved_sigmask);
}

static inline __attribute__((no_instrument_function)) sigset_t *sigmask_to_=
save(void)
{
 sigset_t *res =3D &get_current()->blocked;
 if (__builtin_expect(!!(test_restore_sigmask()), 0))
  res =3D &get_current()->saved_sigmask;
 return res;
}

static inline __attribute__((no_instrument_function)) int kill_cad_pid(int =
sig, int priv)
{
 return kill_pid(cad_pid, sig, priv);
}
# 2064 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) int on_sig_stack(unsi=
gned long sp)
{




 return sp > get_current()->sas_ss_sp &&
  sp - get_current()->sas_ss_sp <=3D get_current()->sas_ss_size;

}

static inline __attribute__((no_instrument_function)) int sas_ss_flags(unsi=
gned long sp)
{
 return (get_current()->sas_ss_size =3D=3D 0 ? 2
  : on_sig_stack(sp) ? 1 : 0);
}

static inline __attribute__((no_instrument_function)) unsigned long sigsp(u=
nsigned long sp, struct ksignal *ksig)
{
 if (__builtin_expect(!!((ksig->ka.sa.sa_flags & 0x08000000u)), 0) && ! sas=
_ss_flags(sp))



  return get_current()->sas_ss_sp + get_current()->sas_ss_size;

 return sp;
}




extern struct mm_struct * mm_alloc(void);


extern void __mmdrop(struct mm_struct *);
static inline __attribute__((no_instrument_function)) void mmdrop(struct mm=
_struct * mm)
{
 if (__builtin_expect(!!(atomic_dec_and_test(&mm->mm_count)), 0))
  __mmdrop(mm);
}


extern void mmput(struct mm_struct *);

extern struct mm_struct *get_task_mm(struct task_struct *task);





extern struct mm_struct *mm_access(struct task_struct *task, unsigned int m=
ode);

extern void mm_release(struct task_struct *, struct mm_struct *);

extern struct mm_struct *dup_mm(struct task_struct *tsk);

extern int copy_thread(unsigned long, unsigned long, unsigned long,
   struct task_struct *);
extern void flush_thread(void);
extern void exit_thread(void);

extern void exit_files(struct task_struct *);
extern void __cleanup_sighand(struct sighand_struct *);

extern void exit_itimers(struct signal_struct *);
extern void flush_itimer_signals(void);

extern void do_group_exit(int);

extern int allow_signal(int);
extern int disallow_signal(int);

extern int do_execve(const char *,
       const char * const *,
       const char * const *);
extern long do_fork(unsigned long, unsigned long, unsigned long, int *, int=
 *);
struct task_struct *fork_idle(int);
extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flag=
s);

extern void set_task_comm(struct task_struct *tsk, char *from);
extern char *get_task_comm(char *to, struct task_struct *tsk);





static inline __attribute__((no_instrument_function)) void scheduler_ipi(vo=
id) { }
static inline __attribute__((no_instrument_function)) unsigned long wait_ta=
sk_inactive(struct task_struct *p,
            long match_state)
{
 return 1;
}
# 2164 "/usr/src/linux-2.6/include/linux/sched.h"
extern bool current_is_single_threaded(void);
# 2176 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) int get_nr_threads(st=
ruct task_struct *tsk)
{
 return tsk->signal->nr_threads;
}

static inline __attribute__((no_instrument_function)) bool thread_group_lea=
der(struct task_struct *p)
{
 return p->exit_signal >=3D 0;
}







static inline __attribute__((no_instrument_function)) bool has_group_leader=
_pid(struct task_struct *p)
{
 return task_pid(p) =3D=3D p->signal->leader_pid;
}

static inline __attribute__((no_instrument_function))
bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
{
 return p1->signal =3D=3D p2->signal;
}

static inline __attribute__((no_instrument_function)) struct task_struct *n=
ext_thread(const struct task_struct *p)
{
 return ({typeof (*p->thread_group.next) *__ptr =3D (typeof (*p->thread_gro=
up.next) *)p->thread_group.next; ({ const typeof( ((struct task_struct *)0)=
->thread_group ) *__mptr =3D ((typeof(p->thread_group.next))({ typeof(*(__p=
tr)) *_________p1 =3D (typeof(*(__ptr))* )(*(volatile typeof((__ptr)) *)&((=
__ptr))); do { } while (0); ; do { } while (0); ((typeof(*(__ptr)) *)(_____=
____p1)); })); (struct task_struct *)( (char *)__mptr - __builtin_offsetof(=
struct task_struct,thread_group) );}); })
                                          ;
}

static inline __attribute__((no_instrument_function)) int thread_group_empt=
y(struct task_struct *p)
{
 return list_empty(&p->thread_group);
}
# 2227 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void task_lock(struct=
 task_struct *p)
{
 spin_lock(&p->alloc_lock);
}

static inline __attribute__((no_instrument_function)) void task_unlock(stru=
ct task_struct *p)
{
 spin_unlock(&p->alloc_lock);
}

extern struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
       unsigned long *flags);

static inline __attribute__((no_instrument_function)) struct sighand_struct=
 *lock_task_sighand(struct task_struct *tsk,
             unsigned long *flags)
{
 struct sighand_struct *ret;

 ret =3D __lock_task_sighand(tsk, flags);
 (void)(ret);
 return ret;
}

static inline __attribute__((no_instrument_function)) void unlock_task_sigh=
and(struct task_struct *tsk,
      unsigned long *flags)
{
 spin_unlock_irqrestore(&tsk->sighand->siglock, *flags);
}


static inline __attribute__((no_instrument_function)) void threadgroup_chan=
ge_begin(struct task_struct *tsk)
{
 down_read(&tsk->signal->group_rwsem);
}
static inline __attribute__((no_instrument_function)) void threadgroup_chan=
ge_end(struct task_struct *tsk)
{
 up_read(&tsk->signal->group_rwsem);
}
# 2282 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void threadgroup_lock=
(struct task_struct *tsk)
{
 down_write(&tsk->signal->group_rwsem);
}







static inline __attribute__((no_instrument_function)) void threadgroup_unlo=
ck(struct task_struct *tsk)
{
 up_write(&tsk->signal->group_rwsem);
}
# 2309 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void setup_thread_sta=
ck(struct task_struct *p, struct task_struct *org)
{
 *((struct thread_info *)(p)->stack) =3D *((struct thread_info *)(org)->sta=
ck);
 ((struct thread_info *)(p)->stack)->task =3D p;
}

static inline __attribute__((no_instrument_function)) unsigned long *end_of=
_stack(struct task_struct *p)
{
 return (unsigned long *)(((struct thread_info *)(p)->stack) + 1);
}



static inline __attribute__((no_instrument_function)) int object_is_on_stac=
k(void *obj)
{
 void *stack =3D ((get_current())->stack);

 return (obj >=3D stack) && (obj < (stack + (((1UL) << 12) << 1)));
}

extern void thread_info_cache_init(void);


static inline __attribute__((no_instrument_function)) unsigned long stack_n=
ot_used(struct task_struct *p)
{
 unsigned long *n =3D end_of_stack(p);

 do {
  n++;
 } while (!*n);

 return (unsigned long)n - (unsigned long)end_of_stack(p);
}





static inline __attribute__((no_instrument_function)) void set_tsk_thread_f=
lag(struct task_struct *tsk, int flag)
{
 set_ti_thread_flag(((struct thread_info *)(tsk)->stack), flag);
}

static inline __attribute__((no_instrument_function)) void clear_tsk_thread=
_flag(struct task_struct *tsk, int flag)
{
 clear_ti_thread_flag(((struct thread_info *)(tsk)->stack), flag);
}

static inline __attribute__((no_instrument_function)) int test_and_set_tsk_=
thread_flag(struct task_struct *tsk, int flag)
{
 return test_and_set_ti_thread_flag(((struct thread_info *)(tsk)->stack), f=
lag);
}

static inline __attribute__((no_instrument_function)) int test_and_clear_ts=
k_thread_flag(struct task_struct *tsk, int flag)
{
 return test_and_clear_ti_thread_flag(((struct thread_info *)(tsk)->stack),=
 flag);
}

static inline __attribute__((no_instrument_function)) int test_tsk_thread_f=
lag(struct task_struct *tsk, int flag)
{
 return test_ti_thread_flag(((struct thread_info *)(tsk)->stack), flag);
}

static inline __attribute__((no_instrument_function)) void set_tsk_need_res=
ched(struct task_struct *tsk)
{
 set_tsk_thread_flag(tsk,3);
}

static inline __attribute__((no_instrument_function)) void clear_tsk_need_r=
esched(struct task_struct *tsk)
{
 clear_tsk_thread_flag(tsk,3);
}

static inline __attribute__((no_instrument_function)) int test_tsk_need_res=
ched(struct task_struct *tsk)
{
 return __builtin_expect(!!(test_tsk_thread_flag(tsk,3)), 0);
}

static inline __attribute__((no_instrument_function)) int restart_syscall(v=
oid)
{
 set_tsk_thread_flag(get_current(), 2);
 return -513;
}

static inline __attribute__((no_instrument_function)) int signal_pending(st=
ruct task_struct *p)
{
 return __builtin_expect(!!(test_tsk_thread_flag(p,2)), 0);
}

static inline __attribute__((no_instrument_function)) int __fatal_signal_pe=
nding(struct task_struct *p)
{
 return __builtin_expect(!!((__builtin_constant_p(9) ? __const_sigismember(=
(&p->pending.signal), (9)) : __gen_sigismember((&p->pending.signal), (9))))=
, 0);
}

static inline __attribute__((no_instrument_function)) int fatal_signal_pend=
ing(struct task_struct *p)
{
 return signal_pending(p) && __fatal_signal_pending(p);
}

static inline __attribute__((no_instrument_function)) int signal_pending_st=
ate(long state, struct task_struct *p)
{
 if (!(state & (1 | 128)))
  return 0;
 if (!signal_pending(p))
  return 0;

 return (state & 1) || __fatal_signal_pending(p);
}
# 2425 "/usr/src/linux-2.6/include/linux/sched.h"
extern int _cond_resched(void);






extern int __cond_resched_lock(spinlock_t *lock);
# 2445 "/usr/src/linux-2.6/include/linux/sched.h"
extern int __cond_resched_softirq(void);






static inline __attribute__((no_instrument_function)) void cond_resched_rcu=
(void)
{

 rcu_read_unlock();
 ({ __might_sleep("/usr/src/linux-2.6/include/linux/sched.h", 2456, 0); _co=
nd_resched(); });
 rcu_read_lock();

}






static inline __attribute__((no_instrument_function)) int spin_needbreak(sp=
inlock_t *lock)
{



 return 0;

}
# 2482 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) int tsk_is_polling(st=
ruct task_struct *p)
{
 return ((struct thread_info *)(p)->stack)->status & 0x0004;
}
static inline __attribute__((no_instrument_function)) void __current_set_po=
lling(void)
{
 current_thread_info()->status |=3D 0x0004;
}

static inline __attribute__((no_instrument_function)) bool __attribute__((w=
arn_unused_result)) current_set_polling_and_test(void)
{
 __current_set_polling();





 __asm__ __volatile__("": : :"memory");

 return __builtin_expect(!!(test_ti_thread_flag(current_thread_info(), 3)),=
 0);
}

static inline __attribute__((no_instrument_function)) void __current_clr_po=
lling(void)
{
 current_thread_info()->status &=3D ~0x0004;
}

static inline __attribute__((no_instrument_function)) bool __attribute__((w=
arn_unused_result)) current_clr_polling_and_test(void)
{
 __current_clr_polling();





 __asm__ __volatile__("": : :"memory");

 return __builtin_expect(!!(test_ti_thread_flag(current_thread_info(), 3)),=
 0);
}
# 2580 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) bool need_resched(void)
{
 return __builtin_expect(!!(test_ti_thread_flag(current_thread_info(), 3)),=
 0);
}




void thread_group_cputime(struct task_struct *tsk, struct task_cputime *tim=
es);
void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *ti=
mes);

static inline __attribute__((no_instrument_function)) void thread_group_cpu=
time_init(struct signal_struct *sig)
{
 do { *(&sig->cputimer.lock) =3D (raw_spinlock_t) { .raw_lock =3D { }, }; }=
 while (0);
}







extern void recalc_sigpending_and_wake(struct task_struct *t);
extern void recalc_sigpending(void);

extern void signal_wake_up_state(struct task_struct *t, unsigned int state);

static inline __attribute__((no_instrument_function)) void signal_wake_up(s=
truct task_struct *t, bool resume)
{
 signal_wake_up_state(t, resume ? 128 : 0);
}
static inline __attribute__((no_instrument_function)) void ptrace_signal_wa=
ke_up(struct task_struct *t, bool resume)
{
 signal_wake_up_state(t, resume ? 8 : 0);
}
# 2630 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) unsigned int task_cpu=
(const struct task_struct *p)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) void set_task_cpu(str=
uct task_struct *p, unsigned int cpu)
{
}



extern long sched_setaffinity(pid_t pid, const struct cpumask *new_mask);
extern long sched_getaffinity(pid_t pid, struct cpumask *mask);


extern struct task_group root_task_group;


extern int task_can_switch_user(struct user_struct *up,
     struct task_struct *tsk);


static inline __attribute__((no_instrument_function)) void add_rchar(struct=
 task_struct *tsk, ssize_t amt)
{
 tsk->ioac.rchar +=3D amt;
}

static inline __attribute__((no_instrument_function)) void add_wchar(struct=
 task_struct *tsk, ssize_t amt)
{
 tsk->ioac.wchar +=3D amt;
}

static inline __attribute__((no_instrument_function)) void inc_syscr(struct=
 task_struct *tsk)
{
 tsk->ioac.syscr++;
}

static inline __attribute__((no_instrument_function)) void inc_syscw(struct=
 task_struct *tsk)
{
 tsk->ioac.syscw++;
}
# 2697 "/usr/src/linux-2.6/include/linux/sched.h"
static inline __attribute__((no_instrument_function)) void mm_update_next_o=
wner(struct mm_struct *mm)
{
}

static inline __attribute__((no_instrument_function)) void mm_init_owner(st=
ruct mm_struct *mm, struct task_struct *p)
{
}


static inline __attribute__((no_instrument_function)) unsigned long task_rl=
imit(const struct task_struct *tsk,
  unsigned int limit)
{
 return (*(volatile typeof(tsk->signal->rlim[limit].rlim_cur) *)&(tsk->sign=
al->rlim[limit].rlim_cur));
}

static inline __attribute__((no_instrument_function)) unsigned long task_rl=
imit_max(const struct task_struct *tsk,
  unsigned int limit)
{
 return (*(volatile typeof(tsk->signal->rlim[limit].rlim_max) *)&(tsk->sign=
al->rlim[limit].rlim_max));
}

static inline __attribute__((no_instrument_function)) unsigned long rlimit(=
unsigned int limit)
{
 return task_rlimit(get_current(), limit);
}

static inline __attribute__((no_instrument_function)) unsigned long rlimit_=
max(unsigned int limit)
{
 return task_rlimit_max(get_current(), limit);
}
# 6 "/usr/src/linux-2.6/include/linux/task_work.h" 2

typedef void (*task_work_func_t)(struct callback_head *);

static inline __attribute__((no_instrument_function)) void
init_task_work(struct callback_head *twork, task_work_func_t func)
{
 twork->func =3D func;
}

int task_work_add(struct task_struct *task, struct callback_head *twork, bo=
ol);
struct callback_head *task_work_cancel(struct task_struct *, task_work_func=
_t);
void task_work_run(void);

static inline __attribute__((no_instrument_function)) void exit_task_work(s=
truct task_struct *task)
{
 task_work_run();
}
# 3 "/usr/src/linux-2.6/kernel/task_work.c" 2
# 1 "/usr/src/linux-2.6/include/linux/tracehook.h" 1
# 50 "/usr/src/linux-2.6/include/linux/tracehook.h"
# 1 "/usr/src/linux-2.6/include/linux/ptrace.h" 1







# 1 "/usr/src/linux-2.6/include/uapi/linux/ptrace.h" 1
# 58 "/usr/src/linux-2.6/include/uapi/linux/ptrace.h"
struct ptrace_peeksiginfo_args {
 __u64 off;
 __u32 flags;
 __s32 nr;
};
# 9 "/usr/src/linux-2.6/include/linux/ptrace.h" 2
# 43 "/usr/src/linux-2.6/include/linux/ptrace.h"
extern long arch_ptrace(struct task_struct *child, long request,
   unsigned long addr, unsigned long data);
extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char=
 *dst, int len);
extern int ptrace_writedata(struct task_struct *tsk, char *src, unsigned lo=
ng dst, int len);
extern void ptrace_disable(struct task_struct *);
extern int ptrace_request(struct task_struct *child, long request,
     unsigned long addr, unsigned long data);
extern void ptrace_notify(int exit_code);
extern void __ptrace_link(struct task_struct *child,
     struct task_struct *new_parent);
extern void __ptrace_unlink(struct task_struct *child);
extern void exit_ptrace(struct task_struct *tracer);




extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);

static inline __attribute__((no_instrument_function)) int ptrace_reparented=
(struct task_struct *child)
{
 return !same_thread_group(child->real_parent, child->parent);
}

static inline __attribute__((no_instrument_function)) void ptrace_unlink(st=
ruct task_struct *child)
{
 if (__builtin_expect(!!(child->ptrace), 0))
  __ptrace_unlink(child);
}

int generic_ptrace_peekdata(struct task_struct *tsk, unsigned long addr,
       unsigned long data);
int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
       unsigned long data);
# 88 "/usr/src/linux-2.6/include/linux/ptrace.h"
static inline __attribute__((no_instrument_function)) struct task_struct *p=
trace_parent(struct task_struct *task)
{
 if (__builtin_expect(!!(task->ptrace), 0))
  return ({ typeof(*(task->parent)) *_________p1 =3D (typeof(*(task->parent=
))* )(*(volatile typeof((task->parent)) *)&((task->parent))); do { } while =
(0); ; do { } while (0); ((typeof(*(task->parent)) *)(_________p1)); });
 return ((void *)0);
}
# 104 "/usr/src/linux-2.6/include/linux/ptrace.h"
static inline __attribute__((no_instrument_function)) bool ptrace_event_ena=
bled(struct task_struct *task, int event)
{
 return task->ptrace & (1 << (3 + (event)));
}
# 119 "/usr/src/linux-2.6/include/linux/ptrace.h"
static inline __attribute__((no_instrument_function)) void ptrace_event(int=
 event, unsigned long message)
{
 if (__builtin_expect(!!(ptrace_event_enabled(get_current(), event)), 0)) {
  get_current()->ptrace_message =3D message;
  ptrace_notify((event << 8) | 5);
 } else if (event =3D=3D 4) {

  if ((get_current()->ptrace & (0x00000001|0x00010000)) =3D=3D 0x00000001)
   send_sig(5, get_current(), 0);
 }
}
# 141 "/usr/src/linux-2.6/include/linux/ptrace.h"
static inline __attribute__((no_instrument_function)) void ptrace_init_task=
(struct task_struct *child, bool ptrace)
{
 INIT_LIST_HEAD(&child->ptrace_entry);
 INIT_LIST_HEAD(&child->ptraced);
 child->jobctl =3D 0;
 child->ptrace =3D 0;
 child->parent =3D child->real_parent;

 if (__builtin_expect(!!(ptrace), 0) && get_current()->ptrace) {
  child->ptrace =3D get_current()->ptrace;
  __ptrace_link(child, get_current()->parent);

  if (child->ptrace & 0x00010000)
   task_set_jobctl_pending(child, (1 << 19));
  else
   (__builtin_constant_p(19) ? __const_sigaddset((&child->pending.signal), =
(19)) : __gen_sigaddset((&child->pending.signal), (19)));

  set_tsk_thread_flag(child, 2);
 }
}







static inline __attribute__((no_instrument_function)) void ptrace_release_t=
ask(struct task_struct *task)
{
 do { if (__builtin_expect(!!(!list_empty(&task->ptraced)), 0)) do { asm vo=
latile("1:\tud2\n" ".pushsection __bug_table,\"a\"\n" "2:\t.long 1b, %c0\n"=
 "\t.word %c1, 0\n" "\t.org 2b+%c2\n" ".popsection" : : "i" ("/usr/src/linu=
x-2.6/include/linux/ptrace.h"), "i" (170), "i" (sizeof(struct bug_entry)));=
 __builtin_unreachable(); } while (0); } while(0);
 ptrace_unlink(task);
 do { if (__builtin_expect(!!(!list_empty(&task->ptrace_entry)), 0)) do { a=
sm volatile("1:\tud2\n" ".pushsection __bug_table,\"a\"\n" "2:\t.long 1b, %=
c0\n" "\t.word %c1, 0\n" "\t.org 2b+%c2\n" ".popsection" : : "i" ("/usr/src=
/linux-2.6/include/linux/ptrace.h"), "i" (172), "i" (sizeof(struct bug_entr=
y))); __builtin_unreachable(); } while (0); } while(0);
}
# 246 "/usr/src/linux-2.6/include/linux/ptrace.h"
extern void user_enable_single_step(struct task_struct *);
extern void user_disable_single_step(struct task_struct *);
# 276 "/usr/src/linux-2.6/include/linux/ptrace.h"
extern void user_enable_block_step(struct task_struct *);



extern void user_single_step_siginfo(struct task_struct *tsk,
    struct pt_regs *regs, siginfo_t *info);
# 347 "/usr/src/linux-2.6/include/linux/ptrace.h"
extern int task_current_syscall(struct task_struct *target, long *callno,
    unsigned long args[6], unsigned int maxargs,
    unsigned long *sp, unsigned long *pc);
# 51 "/usr/src/linux-2.6/include/linux/tracehook.h" 2
# 1 "/usr/src/linux-2.6/include/linux/security.h" 1
# 27 "/usr/src/linux-2.6/include/linux/security.h"
# 1 "/usr/src/linux-2.6/include/linux/slab.h" 1
# 99 "/usr/src/linux-2.6/include/linux/slab.h"
# 1 "/usr/src/linux-2.6/include/linux/kmemleak.h" 1
# 61 "/usr/src/linux-2.6/include/linux/kmemleak.h"
static inline __attribute__((no_instrument_function)) void kmemleak_init(vo=
id)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_alloc(c=
onst void *ptr, size_t size, int min_count,
      gfp_t gfp)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_alloc_r=
ecursive(const void *ptr, size_t size,
         int min_count, unsigned long flags,
         gfp_t gfp)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_alloc_p=
ercpu(const void *ptr, size_t size)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_free(co=
nst void *ptr)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_free_pa=
rt(const void *ptr, size_t size)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_free_re=
cursive(const void *ptr, unsigned long flags)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_free_pe=
rcpu(const void *ptr)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_not_lea=
k(const void *ptr)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_ignore(=
const void *ptr)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_scan_ar=
ea(const void *ptr, size_t size, gfp_t gfp)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_erase(v=
oid **ptr)
{
}
static inline __attribute__((no_instrument_function)) void kmemleak_no_scan=
(const void *ptr)
{
}
# 100 "/usr/src/linux-2.6/include/linux/slab.h" 2

struct mem_cgroup;



void __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) =
__attribute__((no_instrument_function)) kmem_cache_init(void);
int slab_is_available(void);

struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
   unsigned long,
   void (*)(void *));
struct kmem_cache *
kmem_cache_create_memcg(struct mem_cgroup *, const char *, size_t, size_t,
   unsigned long, void (*)(void *), struct kmem_cache *);
void kmem_cache_destroy(struct kmem_cache *);
int kmem_cache_shrink(struct kmem_cache *);
void kmem_cache_free(struct kmem_cache *, void *);
# 133 "/usr/src/linux-2.6/include/linux/slab.h"
void * __attribute__((warn_unused_result)) __krealloc(const void *, size_t,=
 gfp_t);
void * __attribute__((warn_unused_result)) krealloc(const void *, size_t, g=
fp_t);
void kfree(const void *);
void kzfree(const void *);
size_t ksize(const void *);
# 239 "/usr/src/linux-2.6/include/linux/slab.h"
extern struct kmem_cache *kmalloc_caches[(12 + 1) + 1];

extern struct kmem_cache *kmalloc_dma_caches[(12 + 1) + 1];
# 252 "/usr/src/linux-2.6/include/linux/slab.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) int kmalloc_index(size_t size)
{
 if (!size)
  return 0;

 if (size <=3D (1 << 3))
  return 3;

 if ((1 << 3) <=3D 32 && size > 64 && size <=3D 96)
  return 1;
 if ((1 << 3) <=3D 64 && size > 128 && size <=3D 192)
  return 2;
 if (size <=3D 8) return 3;
 if (size <=3D 16) return 4;
 if (size <=3D 32) return 5;
 if (size <=3D 64) return 6;
 if (size <=3D 128) return 7;
 if (size <=3D 256) return 8;
 if (size <=3D 512) return 9;
 if (size <=3D 1024) return 10;
 if (size <=3D 2 * 1024) return 11;
 if (size <=3D 4 * 1024) return 12;
 if (size <=3D 8 * 1024) return 13;
 if (size <=3D 16 * 1024) return 14;
 if (size <=3D 32 * 1024) return 15;
 if (size <=3D 64 * 1024) return 16;
 if (size <=3D 128 * 1024) return 17;
 if (size <=3D 256 * 1024) return 18;
 if (size <=3D 512 * 1024) return 19;
 if (size <=3D 1024 * 1024) return 20;
 if (size <=3D 2 * 1024 * 1024) return 21;
 if (size <=3D 4 * 1024 * 1024) return 22;
 if (size <=3D 8 * 1024 * 1024) return 23;
 if (size <=3D 16 * 1024 * 1024) return 24;
 if (size <=3D 32 * 1024 * 1024) return 25;
 if (size <=3D 64 * 1024 * 1024) return 26;
 do { asm volatile("1:\tud2\n" ".pushsection __bug_table,\"a\"\n" "2:\t.lon=
g 1b, %c0\n" "\t.word %c1, 0\n" "\t.org 2b+%c2\n" ".popsection" : : "i" ("/=
usr/src/linux-2.6/include/linux/slab.h"), "i" (288), "i" (sizeof(struct bug=
_entry))); __builtin_unreachable(); } while (0);


 return -1;
}


void *__kmalloc(size_t size, gfp_t flags);
void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags);





static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *__kmalloc_node(size_t size, gfp_t flags, int node)
{
 return __kmalloc(size, flags);
}

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t flags, in=
t node)
{
 return kmem_cache_alloc(s, flags);
}



extern void *kmem_cache_alloc_trace(struct kmem_cache *, gfp_t, size_t);






static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *
kmem_cache_alloc_node_trace(struct kmem_cache *s,
         gfp_t gfpflags,
         int node, size_t size)
{
 return kmem_cache_alloc_trace(s, gfpflags, size);
}
# 351 "/usr/src/linux-2.6/include/linux/slab.h"
# 1 "/usr/src/linux-2.6/include/linux/slub_def.h" 1
# 9 "/usr/src/linux-2.6/include/linux/slub_def.h"
# 1 "/usr/src/linux-2.6/include/linux/kobject.h" 1
# 21 "/usr/src/linux-2.6/include/linux/kobject.h"
# 1 "/usr/src/linux-2.6/include/linux/sysfs.h" 1
# 19 "/usr/src/linux-2.6/include/linux/sysfs.h"
# 1 "/usr/src/linux-2.6/include/linux/kobject_ns.h" 1
# 20 "/usr/src/linux-2.6/include/linux/kobject_ns.h"
struct sock;
struct kobject;





enum kobj_ns_type {
 KOBJ_NS_TYPE_NONE =3D 0,
 KOBJ_NS_TYPE_NET,
 KOBJ_NS_TYPES
};
# 40 "/usr/src/linux-2.6/include/linux/kobject_ns.h"
struct kobj_ns_type_operations {
 enum kobj_ns_type type;
 bool (*current_may_mount)(void);
 void *(*grab_current_ns)(void);
 const void *(*netlink_ns)(struct sock *sk);
 const void *(*initial_ns)(void);
 void (*drop_ns)(void *);
};

int kobj_ns_type_register(const struct kobj_ns_type_operations *ops);
int kobj_ns_type_registered(enum kobj_ns_type type);
const struct kobj_ns_type_operations *kobj_child_ns_ops(struct kobject *par=
ent);
const struct kobj_ns_type_operations *kobj_ns_ops(struct kobject *kobj);

bool kobj_ns_current_may_mount(enum kobj_ns_type type);
void *kobj_ns_grab_current(enum kobj_ns_type type);
const void *kobj_ns_netlink(enum kobj_ns_type type, struct sock *sk);
const void *kobj_ns_initial(enum kobj_ns_type type);
void kobj_ns_drop(enum kobj_ns_type type, void *ns);
# 20 "/usr/src/linux-2.6/include/linux/sysfs.h" 2
# 1 "/usr/src/linux-2.6/include/linux/stat.h" 1




# 1 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/stat.h" 1






struct stat {
 unsigned long st_dev;
 unsigned long st_ino;
 unsigned short st_mode;
 unsigned short st_nlink;
 unsigned short st_uid;
 unsigned short st_gid;
 unsigned long st_rdev;
 unsigned long st_size;
 unsigned long st_blksize;
 unsigned long st_blocks;
 unsigned long st_atime;
 unsigned long st_atime_nsec;
 unsigned long st_mtime;
 unsigned long st_mtime_nsec;
 unsigned long st_ctime;
 unsigned long st_ctime_nsec;
 unsigned long __unused4;
 unsigned long __unused5;
};
# 39 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/stat.h"
struct stat64 {
 unsigned long long st_dev;
 unsigned char __pad0[4];

 unsigned long __st_ino;

 unsigned int st_mode;
 unsigned int st_nlink;

 unsigned long st_uid;
 unsigned long st_gid;

 unsigned long long st_rdev;
 unsigned char __pad3[4];

 long long st_size;
 unsigned long st_blksize;


 unsigned long long st_blocks;

 unsigned long st_atime;
 unsigned long st_atime_nsec;

 unsigned long st_mtime;
 unsigned int st_mtime_nsec;

 unsigned long st_ctime;
 unsigned long st_ctime_nsec;

 unsigned long long st_ino;
};
# 114 "/usr/src/linux-2.6/arch/x86/include/uapi/asm/stat.h"
struct __old_kernel_stat {
 unsigned short st_dev;
 unsigned short st_ino;
 unsigned short st_mode;
 unsigned short st_nlink;
 unsigned short st_uid;
 unsigned short st_gid;
 unsigned short st_rdev;

 unsigned long st_size;
 unsigned long st_atime;
 unsigned long st_mtime;
 unsigned long st_ctime;






};
# 6 "/usr/src/linux-2.6/include/linux/stat.h" 2
# 1 "/usr/src/linux-2.6/include/uapi/linux/stat.h" 1
# 7 "/usr/src/linux-2.6/include/linux/stat.h" 2
# 21 "/usr/src/linux-2.6/include/linux/stat.h"
struct kstat {
 u64 ino;
 dev_t dev;
 umode_t mode;
 unsigned int nlink;
 kuid_t uid;
 kgid_t gid;
 dev_t rdev;
 loff_t size;
 struct timespec atime;
 struct timespec mtime;
 struct timespec ctime;
 unsigned long blksize;
 unsigned long long blocks;
};
# 21 "/usr/src/linux-2.6/include/linux/sysfs.h" 2


struct kobject;
struct module;
struct bin_attribute;
enum kobj_ns_type;

struct attribute {
 const char *name;
 umode_t mode;





};
# 59 "/usr/src/linux-2.6/include/linux/sysfs.h"
struct attribute_group {
 const char *name;
 umode_t (*is_visible)(struct kobject *,
           struct attribute *, int);
 struct attribute **attrs;
 struct bin_attribute **bin_attrs;
};
# 116 "/usr/src/linux-2.6/include/linux/sysfs.h"
struct file;
struct vm_area_struct;

struct bin_attribute {
 struct attribute attr;
 size_t size;
 void *private;
 ssize_t (*read)(struct file *, struct kobject *, struct bin_attribute *,
   char *, loff_t, size_t);
 ssize_t (*write)(struct file *, struct kobject *, struct bin_attribute *,
    char *, loff_t, size_t);
 int (*mmap)(struct file *, struct kobject *, struct bin_attribute *attr,
      struct vm_area_struct *vma);
};
# 173 "/usr/src/linux-2.6/include/linux/sysfs.h"
struct sysfs_ops {
 ssize_t (*show)(struct kobject *, struct attribute *, char *);
 ssize_t (*store)(struct kobject *, struct attribute *, const char *, size_=
t);
 const void *(*namespace)(struct kobject *, const struct attribute *);
};

struct sysfs_dirent;



int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
       void *data, struct module *owner);

int __attribute__((warn_unused_result)) sysfs_create_dir(struct kobject *ko=
bj);
void sysfs_remove_dir(struct kobject *kobj);
int __attribute__((warn_unused_result)) sysfs_rename_dir(struct kobject *ko=
bj, const char *new_name);
int __attribute__((warn_unused_result)) sysfs_move_dir(struct kobject *kobj,
    struct kobject *new_parent_kobj);

int __attribute__((warn_unused_result)) sysfs_create_file(struct kobject *k=
obj,
       const struct attribute *attr);
int __attribute__((warn_unused_result)) sysfs_create_files(struct kobject *=
kobj,
       const struct attribute **attr);
int __attribute__((warn_unused_result)) sysfs_chmod_file(struct kobject *ko=
bj,
      const struct attribute *attr, umode_t mode);
void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
void sysfs_remove_files(struct kobject *kobj, const struct attribute **attr=
);

int __attribute__((warn_unused_result)) sysfs_create_bin_file(struct kobjec=
t *kobj,
           const struct bin_attribute *attr);
void sysfs_remove_bin_file(struct kobject *kobj,
      const struct bin_attribute *attr);

int __attribute__((warn_unused_result)) sysfs_create_link(struct kobject *k=
obj, struct kobject *target,
       const char *name);
int __attribute__((warn_unused_result)) sysfs_create_link_nowarn(struct kob=
ject *kobj,
       struct kobject *target,
       const char *name);
void sysfs_remove_link(struct kobject *kobj, const char *name);

int sysfs_rename_link(struct kobject *kobj, struct kobject *target,
   const char *old_name, const char *new_name);

void sysfs_delete_link(struct kobject *dir, struct kobject *targ,
   const char *name);

int __attribute__((warn_unused_result)) sysfs_create_group(struct kobject *=
kobj,
        const struct attribute_group *grp);
int __attribute__((warn_unused_result)) sysfs_create_groups(struct kobject =
*kobj,
         const struct attribute_group **groups);
int sysfs_update_group(struct kobject *kobj,
         const struct attribute_group *grp);
void sysfs_remove_group(struct kobject *kobj,
   const struct attribute_group *grp);
void sysfs_remove_groups(struct kobject *kobj,
    const struct attribute_group **groups);
int sysfs_add_file_to_group(struct kobject *kobj,
   const struct attribute *attr, const char *group);
void sysfs_remove_file_from_group(struct kobject *kobj,
   const struct attribute *attr, const char *group);
int sysfs_merge_group(struct kobject *kobj,
         const struct attribute_group *grp);
void sysfs_unmerge_group(struct kobject *kobj,
         const struct attribute_group *grp);
int sysfs_add_link_to_group(struct kobject *kobj, const char *group_name,
       struct kobject *target, const char *link_name);
void sysfs_remove_link_from_group(struct kobject *kobj, const char *group_n=
ame,
      const char *link_name);

void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
void sysfs_notify_dirent(struct sysfs_dirent *sd);
struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
          const void *ns,
          const unsigned char *name);
struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd);
void sysfs_put(struct sysfs_dirent *sd);

int __attribute__((warn_unused_result)) sysfs_init(void);
# 22 "/usr/src/linux-2.6/include/linux/kobject.h" 2


# 1 "/usr/src/linux-2.6/include/linux/kref.h" 1
# 24 "/usr/src/linux-2.6/include/linux/kref.h"
struct kref {
 atomic_t refcount;
};





static inline __attribute__((no_instrument_function)) void kref_init(struct=
 kref *kref)
{
 atomic_set(&kref->refcount, 1);
}





static inline __attribute__((no_instrument_function)) void kref_get(struct =
kref *kref)
{




 ({ static bool __attribute__ ((__section__(".data.unlikely"))) __warned; i=
nt __ret_warn_once =3D !!((atomic_add_return(1, &kref->refcount)) < 2); if =
(__builtin_expect(!!(__ret_warn_once), 0)) if (({ int __ret_warn_on =3D !!(=
!__warned); if (__builtin_expect(!!(__ret_warn_on), 0)) warn_slowpath_null(=
"/usr/src/linux-2.6/include/linux/kref.h", 47); __builtin_expect(!!(__ret_w=
arn_on), 0); })) __warned =3D true; __builtin_expect(!!(__ret_warn_once), 0=
); });
}
# 68 "/usr/src/linux-2.6/include/linux/kref.h"
static inline __attribute__((no_instrument_function)) int kref_sub(struct k=
ref *kref, unsigned int count,
      void (*release)(struct kref *kref))
{
 ({ int __ret_warn_on =3D !!(release =3D=3D ((void *)0)); if (__builtin_exp=
ect(!!(__ret_warn_on), 0)) warn_slowpath_null("/usr/src/linux-2.6/include/l=
inux/kref.h", 71); __builtin_expect(!!(__ret_warn_on), 0); });

 if (atomic_sub_and_test((int) count, &kref->refcount)) {
  release(kref);
  return 1;
 }
 return 0;
}
# 97 "/usr/src/linux-2.6/include/linux/kref.h"
static inline __attribute__((no_instrument_function)) int kref_put(struct k=
ref *kref, void (*release)(struct kref *kref))
{
 return kref_sub(kref, 1, release);
}
# 115 "/usr/src/linux-2.6/include/linux/kref.h"
static inline __attribute__((no_instrument_function)) int kref_put_spinlock=
_irqsave(struct kref *kref,
  void (*release)(struct kref *kref),
  spinlock_t *lock)
{
 unsigned long flags;

 ({ int __ret_warn_on =3D !!(release =3D=3D ((void *)0)); if (__builtin_exp=
ect(!!(__ret_warn_on), 0)) warn_slowpath_null("/usr/src/linux-2.6/include/l=
inux/kref.h", 121); __builtin_expect(!!(__ret_warn_on), 0); });
 if (atomic_add_unless(&kref->refcount, -1, 1))
  return 0;
 do { do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dumm=
y =3D=3D &__dummy2); 1; }); do { do { do { ({ unsigned long __dummy; typeof=
(flags) __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); flags =3D arch_=
local_irq_save(); } while (0); do { } while (0); } while (0); do { __asm__ =
__volatile__("": : :"memory"); (void)0; (void)(spinlock_check(lock)); } whi=
le (0); } while (0); } while (0); } while (0);
 if (atomic_dec_and_test(&kref->refcount)) {
  release(kref);
  do { if (({ ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__d=
ummy =3D=3D &__dummy2); 1; }); arch_irqs_disabled_flags(flags); })) { do { =
({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=3D &_=
_dummy2); 1; }); arch_local_irq_restore(flags); } while (0); do { } while (=
0); } else { do { } while (0); do { ({ unsigned long __dummy; typeof(flags)=
 __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); arch_local_irq_restore=
(flags); } while (0); } } while (0);
  return 1;
 }
 spin_unlock_irqrestore(lock, flags);
 return 0;
}

static inline __attribute__((no_instrument_function)) int kref_put_mutex(st=
ruct kref *kref,
     void (*release)(struct kref *kref),
     struct mutex *lock)
{
 ({ int __ret_warn_on =3D !!(release =3D=3D ((void *)0)); if (__builtin_exp=
ect(!!(__ret_warn_on), 0)) warn_slowpath_null("/usr/src/linux-2.6/include/l=
inux/kref.h", 138); __builtin_expect(!!(__ret_warn_on), 0); });
 if (__builtin_expect(!!(!atomic_add_unless(&kref->refcount, -1, 1)), 0)) {
  mutex_lock(lock);
  if (__builtin_expect(!!(!atomic_dec_and_test(&kref->refcount)), 0)) {
   mutex_unlock(lock);
   return 0;
  }
  release(kref);
  return 1;
 }
 return 0;
}
# 167 "/usr/src/linux-2.6/include/linux/kref.h"
static inline __attribute__((no_instrument_function)) int __attribute__((wa=
rn_unused_result)) kref_get_unless_zero(struct kref *kref)
{
 return atomic_add_unless(&kref->refcount, 1, 0);
}
# 25 "/usr/src/linux-2.6/include/linux/kobject.h" 2
# 36 "/usr/src/linux-2.6/include/linux/kobject.h"
extern char uevent_helper[];


extern u64 uevent_seqnum;
# 51 "/usr/src/linux-2.6/include/linux/kobject.h"
enum kobject_action {
 KOBJ_ADD,
 KOBJ_REMOVE,
 KOBJ_CHANGE,
 KOBJ_MOVE,
 KOBJ_ONLINE,
 KOBJ_OFFLINE,
 KOBJ_MAX
};

struct kobject {
 const char *name;
 struct list_head entry;
 struct kobject *parent;
 struct kset *kset;
 struct kobj_type *ktype;
 struct sysfs_dirent *sd;
 struct kref kref;



 unsigned int state_initialized:1;
 unsigned int state_in_sysfs:1;
 unsigned int state_add_uevent_sent:1;
 unsigned int state_remove_uevent_sent:1;
 unsigned int uevent_suppress:1;
};

extern __attribute__((format(printf, 2, 3)))
int kobject_set_name(struct kobject *kobj, const char *name, ...);
extern int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
      va_list vargs);

static inline __attribute__((no_instrument_function)) const char *kobject_n=
ame(const struct kobject *kobj)
{
 return kobj->name;
}

extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
extern __attribute__((format(printf, 3, 4))) __attribute__((warn_unused_res=
ult))
int kobject_add(struct kobject *kobj, struct kobject *parent,
  const char *fmt, ...);
extern __attribute__((format(printf, 4, 5))) __attribute__((warn_unused_res=
ult))
int kobject_init_and_add(struct kobject *kobj,
    struct kobj_type *ktype, struct kobject *parent,
    const char *fmt, ...);

extern void kobject_del(struct kobject *kobj);

extern struct kobject * __attribute__((warn_unused_result)) kobject_create(=
void);
extern struct kobject * __attribute__((warn_unused_result)) kobject_create_=
and_add(const char *name,
      struct kobject *parent);

extern int __attribute__((warn_unused_result)) kobject_rename(struct kobjec=
t *, const char *new_name);
extern int __attribute__((warn_unused_result)) kobject_move(struct kobject =
*, struct kobject *);

extern struct kobject *kobject_get(struct kobject *kobj);
extern void kobject_put(struct kobject *kobj);

extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);

struct kobj_type {
 void (*release)(struct kobject *kobj);
 const struct sysfs_ops *sysfs_ops;
 struct attribute **default_attrs;
 const struct kobj_ns_type_operations *(*child_ns_type)(struct kobject *kob=
j);
 const void *(*namespace)(struct kobject *kobj);
};

struct kobj_uevent_env {
 char *envp[32];
 int envp_idx;
 char buf[2048];
 int buflen;
};

struct kset_uevent_ops {
 int (* const filter)(struct kset *kset, struct kobject *kobj);
 const char *(* const name)(struct kset *kset, struct kobject *kobj);
 int (* const uevent)(struct kset *kset, struct kobject *kobj,
        struct kobj_uevent_env *env);
};

struct kobj_attribute {
 struct attribute attr;
 ssize_t (*show)(struct kobject *kobj, struct kobj_attribute *attr,
   char *buf);
 ssize_t (*store)(struct kobject *kobj, struct kobj_attribute *attr,
    const char *buf, size_t count);
};

extern const struct sysfs_ops kobj_sysfs_ops;

struct sock;
# 163 "/usr/src/linux-2.6/include/linux/kobject.h"
struct kset {
 struct list_head list;
 spinlock_t list_lock;
 struct kobject kobj;
 const struct kset_uevent_ops *uevent_ops;
};

extern void kset_init(struct kset *kset);
extern int __attribute__((warn_unused_result)) kset_register(struct kset *k=
set);
extern void kset_unregister(struct kset *kset);
extern struct kset * __attribute__((warn_unused_result)) kset_create_and_ad=
d(const char *name,
      const struct kset_uevent_ops *u,
      struct kobject *parent_kobj);

static inline __attribute__((no_instrument_function)) struct kset *to_kset(=
struct kobject *kobj)
{
 return kobj ? ({ const typeof( ((struct kset *)0)->kobj ) *__mptr =3D (kob=
j); (struct kset *)( (char *)__mptr - __builtin_offsetof(struct kset,kobj) =
);}) : ((void *)0);
}

static inline __attribute__((no_instrument_function)) struct kset *kset_get=
(struct kset *k)
{
 return k ? to_kset(kobject_get(&k->kobj)) : ((void *)0);
}

static inline __attribute__((no_instrument_function)) void kset_put(struct =
kset *k)
{
 kobject_put(&k->kobj);
}

static inline __attribute__((no_instrument_function)) struct kobj_type *get=
_ktype(struct kobject *kobj)
{
 return kobj->ktype;
}

extern struct kobject *kset_find_obj(struct kset *, const char *);


extern struct kobject *kernel_kobj;

extern struct kobject *mm_kobj;

extern struct kobject *hypervisor_kobj;

extern struct kobject *power_kobj;

extern struct kobject *firmware_kobj;

int kobject_uevent(struct kobject *kobj, enum kobject_action action);
int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
   char *envp[]);

__attribute__((format(printf, 2, 3)))
int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...);

int kobject_action_type(const char *buf, size_t count,
   enum kobject_action *type);
# 10 "/usr/src/linux-2.6/include/linux/slub_def.h" 2

enum stat_item {
 ALLOC_FASTPATH,
 ALLOC_SLOWPATH,
 FREE_FASTPATH,
 FREE_SLOWPATH,
 FREE_FROZEN,
 FREE_ADD_PARTIAL,
 FREE_REMOVE_PARTIAL,
 ALLOC_FROM_PARTIAL,
 ALLOC_SLAB,
 ALLOC_REFILL,
 ALLOC_NODE_MISMATCH,
 FREE_SLAB,
 CPUSLAB_FLUSH,
 DEACTIVATE_FULL,
 DEACTIVATE_EMPTY,
 DEACTIVATE_TO_HEAD,
 DEACTIVATE_TO_TAIL,
 DEACTIVATE_REMOTE_FREES,
 DEACTIVATE_BYPASS,
 ORDER_FALLBACK,
 CMPXCHG_DOUBLE_CPU_FAIL,
 CMPXCHG_DOUBLE_FAIL,
 CPU_PARTIAL_ALLOC,
 CPU_PARTIAL_FREE,
 CPU_PARTIAL_NODE,
 CPU_PARTIAL_DRAIN,
 NR_SLUB_STAT_ITEMS };

struct kmem_cache_cpu {
 void **freelist;
 unsigned long tid;
 struct page *page;
 struct page *partial;



};






struct kmem_cache_order_objects {
 unsigned long x;
};




struct kmem_cache {
 struct kmem_cache_cpu *cpu_slab;

 unsigned long flags;
 unsigned long min_partial;
 int size;
 int object_size;
 int offset;
 int cpu_partial;
 struct kmem_cache_order_objects oo;


 struct kmem_cache_order_objects max;
 struct kmem_cache_order_objects min;
 gfp_t allocflags;
 int refcount;
 void (*ctor)(void *);
 int inuse;
 int align;
 int reserved;
 const char *name;
 struct list_head list;

 struct kobject kobj;
# 98 "/usr/src/linux-2.6/include/linux/slub_def.h"
 struct kmem_cache_node *node[(1 << 0)];
};
# 352 "/usr/src/linux-2.6/include/linux/slab.h" 2


static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *
kmalloc_order(size_t size, gfp_t flags, unsigned int order)
{
 void *ret;

 flags |=3D ((( gfp_t)0x4000u) | (( gfp_t)0x100000u));
 ret =3D (void *) __get_free_pages(flags, order);
 kmemleak_alloc(ret, size, 1, flags);
 return ret;
}


extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int ord=
er);
# 375 "/usr/src/linux-2.6/include/linux/slab.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *kmalloc_large(size_t size, gfp_t flags)
{
 unsigned int order =3D ( __builtin_constant_p(size) ? ( ((size) =3D=3D 0UL=
) ? 32 - 12 : (((size) < (1UL << 12)) ? 0 : ( __builtin_constant_p((size) -=
 1) ? ( ((size) - 1) < 1 ? ____ilog2_NaN() : ((size) - 1) & (1ULL << 63) ? =
63 : ((size) - 1) & (1ULL << 62) ? 62 : ((size) - 1) & (1ULL << 61) ? 61 : =
((size) - 1) & (1ULL << 60) ? 60 : ((size) - 1) & (1ULL << 59) ? 59 : ((siz=
e) - 1) & (1ULL << 58) ? 58 : ((size) - 1) & (1ULL << 57) ? 57 : ((size) - =
1) & (1ULL << 56) ? 56 : ((size) - 1) & (1ULL << 55) ? 55 : ((size) - 1) & =
(1ULL << 54) ? 54 : ((size) - 1) & (1ULL << 53) ? 53 : ((size) - 1) & (1ULL=
 << 52) ? 52 : ((size) - 1) & (1ULL << 51) ? 51 : ((size) - 1) & (1ULL << 5=
0) ? 50 : ((size) - 1) & (1ULL << 49) ? 49 : ((size) - 1) & (1ULL << 48) ? =
48 : ((size) - 1) & (1ULL << 47) ? 47 : ((size) - 1) & (1ULL << 46) ? 46 : =
((size) - 1) & (1ULL << 45) ? 45 : ((size) - 1) & (1ULL << 44) ? 44 : ((siz=
e) - 1) & (1ULL << 43) ? 43 : ((size) - 1) & (1ULL << 42) ? 42 : ((size) - =
1) & (1ULL << 41) ? 41 : ((size) - 1) & (1ULL << 40) ? 40 : ((size) - 1) & =
(1ULL << 39) ? 39 : ((size) - 1) & (1ULL << 38) ? 38 : ((size) - 1) & (1ULL=
 << 37) ? 37 : ((size) - 1) & (1ULL << 36) ? 36 : ((size) - 1) & (1ULL << 3=
5) ? 35 : ((size) - 1) & (1ULL << 34) ? 34 : ((size) - 1) & (1ULL << 33) ? =
33 : ((size) - 1) & (1ULL << 32) ? 32 : ((size) - 1) & (1ULL << 31) ? 31 : =
((size) - 1) & (1ULL << 30) ? 30 : ((size) - 1) & (1ULL << 29) ? 29 : ((siz=
e) - 1) & (1ULL << 28) ? 28 : ((size) - 1) & (1ULL << 27) ? 27 : ((size) - =
1) & (1ULL << 26) ? 26 : ((size) - 1) & (1ULL << 25) ? 25 : ((size) - 1) & =
(1ULL << 24) ? 24 : ((size) - 1) & (1ULL << 23) ? 23 : ((size) - 1) & (1ULL=
 << 22) ? 22 : ((size) - 1) & (1ULL << 21) ? 21 : ((size) - 1) & (1ULL << 2=
0) ? 20 : ((size) - 1) & (1ULL << 19) ? 19 : ((size) - 1) & (1ULL << 18) ? =
18 : ((size) - 1) & (1ULL << 17) ? 17 : ((size) - 1) & (1ULL << 16) ? 16 : =
((size) - 1) & (1ULL << 15) ? 15 : ((size) - 1) & (1ULL << 14) ? 14 : ((siz=
e) - 1) & (1ULL << 13) ? 13 : ((size) - 1) & (1ULL << 12) ? 12 : ((size) - =
1) & (1ULL << 11) ? 11 : ((size) - 1) & (1ULL << 10) ? 10 : ((size) - 1) & =
(1ULL << 9) ? 9 : ((size) - 1) & (1ULL << 8) ? 8 : ((size) - 1) & (1ULL << =
7) ? 7 : ((size) - 1) & (1ULL << 6) ? 6 : ((size) - 1) & (1ULL << 5) ? 5 : =
((size) - 1) & (1ULL << 4) ? 4 : ((size) - 1) & (1ULL << 3) ? 3 : ((size) -=
 1) & (1ULL << 2) ? 2 : ((size) - 1) & (1ULL << 1) ? 1 : ((size) - 1) & (1U=
LL << 0) ? 0 : ____ilog2_NaN() ) : (sizeof((size) - 1) <=3D 4) ? __ilog2_u3=
2((size) - 1) : __ilog2_u64((size) - 1) ) - 12 + 1) ) : __get_order(size) );
 return kmalloc_order_trace(size, flags, order);
}
# 389 "/usr/src/linux-2.6/include/linux/slab.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *kmalloc(size_t size, gfp_t flags)
{
 if (__builtin_constant_p(size)) {
  if (size > (1UL << (12 + 1)))
   return kmalloc_large(size, flags);

  if (!(flags & (( gfp_t)0x01u))) {
   int index =3D kmalloc_index(size);

   if (!index)
    return ((void *)16);

   return kmem_cache_alloc_trace(kmalloc_caches[index],
     flags, size);
  }

 }
 return __kmalloc(size, flags);
}






static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) int kmalloc_size(int n)
{

 if (n > 2)
  return 1 << n;

 if (n =3D=3D 1 && (1 << 3) <=3D 32)
  return 96;

 if (n =3D=3D 2 && (1 << 3) <=3D 64)
  return 192;

 return 0;
}

static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *kmalloc_node(size_t size, gfp_t flags, int node)
{

 if (__builtin_constant_p(size) &&
  size <=3D (1UL << (12 + 1)) && !(flags & (( gfp_t)0x01u))) {
  int i =3D kmalloc_index(size);

  if (!i)
   return ((void *)16);

  return kmem_cache_alloc_node_trace(kmalloc_caches[i],
      flags, node, size);
 }

 return __kmalloc_node(size, flags, node);
}
# 476 "/usr/src/linux-2.6/include/linux/slab.h"
struct memcg_cache_params {
 bool is_root_cache;
 union {
  struct kmem_cache *memcg_caches[0];
  struct {
   struct mem_cgroup *memcg;
   struct list_head list;
   struct kmem_cache *root_cache;
   bool dead;
   atomic_t nr_pages;
   struct work_struct destroy;
  };
 };
};

int memcg_update_all_caches(int num_memcgs);

struct seq_file;
int cache_show(struct kmem_cache *s, struct seq_file *m);
void print_slabinfo_header(struct seq_file *m);
# 550 "/usr/src/linux-2.6/include/linux/slab.h"
static inline __attribute__((no_instrument_function)) __attribute__((always=
_inline)) void *kmalloc(size_t size, gfp_t flags);







static inline __attribute__((no_instrument_function)) void *kmalloc_array(s=
ize_t n, size_t size, gfp_t flags)
{
 if (size !=3D 0 && n > (~(size_t)0) / size)
  return ((void *)0);
 return __kmalloc(n * size, flags);
}







static inline __attribute__((no_instrument_function)) void *kcalloc(size_t =
n, size_t size, gfp_t flags)
{
 return kmalloc_array(n, size, flags | (( gfp_t)0x8000u));
}
# 587 "/usr/src/linux-2.6/include/linux/slab.h"
extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
# 626 "/usr/src/linux-2.6/include/linux/slab.h"
static inline __attribute__((no_instrument_function)) void *kmem_cache_zall=
oc(struct kmem_cache *k, gfp_t flags)
{
 return kmem_cache_alloc(k, flags | (( gfp_t)0x8000u));
}






static inline __attribute__((no_instrument_function)) void *kzalloc(size_t =
size, gfp_t flags)
{
 return kmalloc(size, flags | (( gfp_t)0x8000u));
}







static inline __attribute__((no_instrument_function)) void *kzalloc_node(si=
ze_t size, gfp_t flags, int node)
{
 return kmalloc_node(size, flags | (( gfp_t)0x8000u), node);
}




static inline __attribute__((no_instrument_function)) unsigned int kmem_cac=
he_size(struct kmem_cache *s)
{
 return s->object_size;
}

void __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) =
__attribute__((no_instrument_function)) kmem_cache_init_late(void);
# 28 "/usr/src/linux-2.6/include/linux/security.h" 2



struct linux_binprm;
struct cred;
struct rlimit;
struct siginfo;
struct sem_array;
struct sembuf;
struct kern_ipc_perm;
struct audit_context;
struct super_block;
struct inode;
struct dentry;
struct file;
struct vfsmount;
struct path;
struct qstr;
struct nameidata;
struct iattr;
struct fown_struct;
struct file_operations;
struct shmid_kernel;
struct msg_msg;
struct msg_queue;
struct xattr;
struct xfrm_sec_ctx;
struct mm_struct;
# 67 "/usr/src/linux-2.6/include/linux/security.h"
struct ctl_table;
struct audit_krule;
struct user_namespace;
struct timezone;





extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
         int cap, int audit);
extern int cap_settime(const struct timespec *ts, const struct timezone *tz=
);
extern int cap_ptrace_access_check(struct task_struct *child, unsigned int =
mode);
extern int cap_ptrace_traceme(struct task_struct *parent);
extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, =
kernel_cap_t *inheritable, kernel_cap_t *permitted);
extern int cap_capset(struct cred *new, const struct cred *old,
        const kernel_cap_t *effective,
        const kernel_cap_t *inheritable,
        const kernel_cap_t *permitted);
extern int cap_bprm_set_creds(struct linux_binprm *bprm);
extern int cap_bprm_secureexec(struct linux_binprm *bprm);
extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
         const void *value, size_t size, int flags);
extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
extern int cap_inode_need_killpriv(struct dentry *dentry);
extern int cap_inode_killpriv(struct dentry *dentry);
extern int cap_mmap_addr(unsigned long addr);
extern int cap_mmap_file(struct file *file, unsigned long reqprot,
    unsigned long prot, unsigned long flags);
extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, in=
t flags);
extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg=
3,
     unsigned long arg4, unsigned long arg5);
extern int cap_task_setscheduler(struct task_struct *p);
extern int cap_task_setioprio(struct task_struct *p, int ioprio);
extern int cap_task_setnice(struct task_struct *p, int nice);
extern int cap_vm_enough_memory(struct mm_struct *mm, long pages);

struct msghdr;
struct sk_buff;
struct sock;
struct sockaddr;
struct socket;
struct flowi;
struct dst_entry;
struct xfrm_selector;
struct xfrm_policy;
struct xfrm_state;
struct xfrm_user_sec_ctx;
struct seq_file;

extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);

void reset_security_ops(void);


extern unsigned long mmap_min_addr;
extern unsigned long dac_mmap_min_addr;
# 145 "/usr/src/linux-2.6/include/linux/security.h"
struct sched_param;
struct request_sock;
# 155 "/usr/src/linux-2.6/include/linux/security.h"
extern int mmap_min_addr_handler(struct ctl_table *table, int write,
     void *buffer, size_t *lenp, loff_t *ppos);



typedef int (*initxattrs) (struct inode *inode,
      const struct xattr *xattr_array, void *fs_data);



struct security_mnt_opts {
 char **mnt_opts;
 int *mnt_opts_flags;
 int num_mnt_opts;
};

static inline __attribute__((no_instrument_function)) void security_init_mn=
t_opts(struct security_mnt_opts *opts)
{
 opts->mnt_opts =3D ((void *)0);
 opts->mnt_opts_flags =3D ((void *)0);
 opts->num_mnt_opts =3D 0;
}

static inline __attribute__((no_instrument_function)) void security_free_mn=
t_opts(struct security_mnt_opts *opts)
{
 int i;
 if (opts->mnt_opts)
  for (i =3D 0; i < opts->num_mnt_opts; i++)
   kfree(opts->mnt_opts[i]);
 kfree(opts->mnt_opts);
 opts->mnt_opts =3D ((void *)0);
 kfree(opts->mnt_opts_flags);
 opts->mnt_opts_flags =3D ((void *)0);
 opts->num_mnt_opts =3D 0;
}
# 1423 "/usr/src/linux-2.6/include/linux/security.h"
struct security_operations {
 char name[10 + 1];

 int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
 int (*ptrace_traceme) (struct task_struct *parent);
 int (*capget) (struct task_struct *target,
         kernel_cap_t *effective,
         kernel_cap_t *inheritable, kernel_cap_t *permitted);
 int (*capset) (struct cred *new,
         const struct cred *old,
         const kernel_cap_t *effective,
         const kernel_cap_t *inheritable,
         const kernel_cap_t *permitted);
 int (*capable) (const struct cred *cred, struct user_namespace *ns,
   int cap, int audit);
 int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
 int (*quota_on) (struct dentry *dentry);
 int (*syslog) (int type);
 int (*settime) (const struct timespec *ts, const struct timezone *tz);
 int (*vm_enough_memory) (struct mm_struct *mm, long pages);

 int (*bprm_set_creds) (struct linux_binprm *bprm);
 int (*bprm_check_security) (struct linux_binprm *bprm);
 int (*bprm_secureexec) (struct linux_binprm *bprm);
 void (*bprm_committing_creds) (struct linux_binprm *bprm);
 void (*bprm_committed_creds) (struct linux_binprm *bprm);

 int (*sb_alloc_security) (struct super_block *sb);
 void (*sb_free_security) (struct super_block *sb);
 int (*sb_copy_data) (char *orig, char *copy);
 int (*sb_remount) (struct super_block *sb, void *data);
 int (*sb_kern_mount) (struct super_block *sb, int flags, void *data);
 int (*sb_show_options) (struct seq_file *m, struct super_block *sb);
 int (*sb_statfs) (struct dentry *dentry);
 int (*sb_mount) (const char *dev_name, struct path *path,
    const char *type, unsigned long flags, void *data);
 int (*sb_umount) (struct vfsmount *mnt, int flags);
 int (*sb_pivotroot) (struct path *old_path,
        struct path *new_path);
 int (*sb_set_mnt_opts) (struct super_block *sb,
    struct security_mnt_opts *opts,
    unsigned long kern_flags,
    unsigned long *set_kern_flags);
 int (*sb_clone_mnt_opts) (const struct super_block *oldsb,
       struct super_block *newsb);
 int (*sb_parse_opts_str) (char *options, struct security_mnt_opts *opts);
 int (*dentry_init_security) (struct dentry *dentry, int mode,
     struct qstr *name, void **ctx,
     u32 *ctxlen);
# 1492 "/usr/src/linux-2.6/include/linux/security.h"
 int (*inode_alloc_security) (struct inode *inode);
 void (*inode_free_security) (struct inode *inode);
 int (*inode_init_security) (struct inode *inode, struct inode *dir,
        const struct qstr *qstr, const char **name,
        void **value, size_t *len);
 int (*inode_create) (struct inode *dir,
        struct dentry *dentry, umode_t mode);
 int (*inode_link) (struct dentry *old_dentry,
      struct inode *dir, struct dentry *new_dentry);
 int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 int (*inode_symlink) (struct inode *dir,
         struct dentry *dentry, const char *old_name);
 int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, umode_t mode=
);
 int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
       umode_t mode, dev_t dev);
 int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
        struct inode *new_dir, struct dentry *new_dentry);
 int (*inode_readlink) (struct dentry *dentry);
 int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 int (*inode_permission) (struct inode *inode, int mask);
 int (*inode_setattr) (struct dentry *dentry, struct iattr *attr);
 int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
 int (*inode_setxattr) (struct dentry *dentry, const char *name,
          const void *value, size_t size, int flags);
 void (*inode_post_setxattr) (struct dentry *dentry, const char *name,
         const void *value, size_t size, int flags);
 int (*inode_getxattr) (struct dentry *dentry, const char *name);
 int (*inode_listxattr) (struct dentry *dentry);
 int (*inode_removexattr) (struct dentry *dentry, const char *name);
 int (*inode_need_killpriv) (struct dentry *dentry);
 int (*inode_killpriv) (struct dentry *dentry);
 int (*inode_getsecurity) (const struct inode *inode, const char *name, voi=
d **buffer, bool alloc);
 int (*inode_setsecurity) (struct inode *inode, const char *name, const voi=
d *value, size_t size, int flags);
 int (*inode_listsecurity) (struct inode *inode, char *buffer, size_t buffe=
r_size);
 void (*inode_getsecid) (const struct inode *inode, u32 *secid);

 int (*file_permission) (struct file *file, int mask);
 int (*file_alloc_security) (struct file *file);
 void (*file_free_security) (struct file *file);
 int (*file_ioctl) (struct file *file, unsigned int cmd,
      unsigned long arg);
 int (*mmap_addr) (unsigned long addr);
 int (*mmap_file) (struct file *file,
     unsigned long reqprot, unsigned long prot,
     unsigned long flags);
 int (*file_mprotect) (struct vm_area_struct *vma,
         unsigned long reqprot,
         unsigned long prot);
 int (*file_lock) (struct file *file, unsigned int cmd);
 int (*file_fcntl) (struct file *file, unsigned int cmd,
      unsigned long arg);
 int (*file_set_fowner) (struct file *file);
 int (*file_send_sigiotask) (struct task_struct *tsk,
        struct fown_struct *fown, int sig);
 int (*file_receive) (struct file *file);
 int (*file_open) (struct file *file, const struct cred *cred);

 int (*task_create) (unsigned long clone_flags);
 void (*task_free) (struct task_struct *task);
 int (*cred_alloc_blank) (struct cred *cred, gfp_t gfp);
 void (*cred_free) (struct cred *cred);
 int (*cred_prepare)(struct cred *new, const struct cred *old,
       gfp_t gfp);
 void (*cred_transfer)(struct cred *new, const struct cred *old);
 int (*kernel_act_as)(struct cred *new, u32 secid);
 int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
 int (*kernel_module_request)(char *kmod_name);
 int (*kernel_module_from_file)(struct file *file);
 int (*task_fix_setuid) (struct cred *new, const struct cred *old,
    int flags);
 int (*task_setpgid) (struct task_struct *p, pid_t pgid);
 int (*task_getpgid) (struct task_struct *p);
 int (*task_getsid) (struct task_struct *p);
 void (*task_getsecid) (struct task_struct *p, u32 *secid);
 int (*task_setnice) (struct task_struct *p, int nice);
 int (*task_setioprio) (struct task_struct *p, int ioprio);
 int (*task_getioprio) (struct task_struct *p);
 int (*task_setrlimit) (struct task_struct *p, unsigned int resource,
   struct rlimit *new_rlim);
 int (*task_setscheduler) (struct task_struct *p);
 int (*task_getscheduler) (struct task_struct *p);
 int (*task_movememory) (struct task_struct *p);
 int (*task_kill) (struct task_struct *p,
     struct siginfo *info, int sig, u32 secid);
 int (*task_wait) (struct task_struct *p);
 int (*task_prctl) (int option, unsigned long arg2,
      unsigned long arg3, unsigned long arg4,
      unsigned long arg5);
 void (*task_to_inode) (struct task_struct *p, struct inode *inode);

 int (*ipc_permission) (struct kern_ipc_perm *ipcp, short flag);
 void (*ipc_getsecid) (struct kern_ipc_perm *ipcp, u32 *secid);

 int (*msg_msg_alloc_security) (struct msg_msg *msg);
 void (*msg_msg_free_security) (struct msg_msg *msg);

 int (*msg_queue_alloc_security) (struct msg_queue *msq);
 void (*msg_queue_free_security) (struct msg_queue *msq);
 int (*msg_queue_associate) (struct msg_queue *msq, int msqflg);
 int (*msg_queue_msgctl) (struct msg_queue *msq, int cmd);
 int (*msg_queue_msgsnd) (struct msg_queue *msq,
     struct msg_msg *msg, int msqflg);
 int (*msg_queue_msgrcv) (struct msg_queue *msq,
     struct msg_msg *msg,
     struct task_struct *target,
     long type, int mode);

 int (*shm_alloc_security) (struct shmid_kernel *shp);
 void (*shm_free_security) (struct shmid_kernel *shp);
 int (*shm_associate) (struct shmid_kernel *shp, int shmflg);
 int (*shm_shmctl) (struct shmid_kernel *shp, int cmd);
 int (*shm_shmat) (struct shmid_kernel *shp,
     char *shmaddr, int shmflg);

 int (*sem_alloc_security) (struct sem_array *sma);
 void (*sem_free_security) (struct sem_array *sma);
 int (*sem_associate) (struct sem_array *sma, int semflg);
 int (*sem_semctl) (struct sem_array *sma, int cmd);
 int (*sem_semop) (struct sem_array *sma,
     struct sembuf *sops, unsigned nsops, int alter);

 int (*netlink_send) (struct sock *sk, struct sk_buff *skb);

 void (*d_instantiate) (struct dentry *dentry, struct inode *inode);

 int (*getprocattr) (struct task_struct *p, char *name, char **value);
 int (*setprocattr) (struct task_struct *p, char *name, void *value, size_t=
 size);
 int (*ismaclabel) (const char *name);
 int (*secid_to_secctx) (u32 secid, char **secdata, u32 *seclen);
 int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
 void (*release_secctx) (char *secdata, u32 seclen);

 int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
 int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
 int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);


 int (*unix_stream_connect) (struct sock *sock, struct sock *other, struct =
sock *newsk);
 int (*unix_may_send) (struct socket *sock, struct socket *other);

 int (*socket_create) (int family, int type, int protocol, int kern);
 int (*socket_post_create) (struct socket *sock, int family,
       int type, int protocol, int kern);
 int (*socket_bind) (struct socket *sock,
       struct sockaddr *address, int addrlen);
 int (*socket_connect) (struct socket *sock,
          struct sockaddr *address, int addrlen);
 int (*socket_listen) (struct socket *sock, int backlog);
 int (*socket_accept) (struct socket *sock, struct socket *newsock);
 int (*socket_sendmsg) (struct socket *sock,
          struct msghdr *msg, int size);
 int (*socket_recvmsg) (struct socket *sock,
          struct msghdr *msg, int size, int flags);
 int (*socket_getsockname) (struct socket *sock);
 int (*socket_getpeername) (struct socket *sock);
 int (*socket_getsockopt) (struct socket *sock, int level, int optname);
 int (*socket_setsockopt) (struct socket *sock, int level, int optname);
 int (*socket_shutdown) (struct socket *sock, int how);
 int (*socket_sock_rcv_skb) (struct sock *sk, struct sk_buff *skb);
 int (*socket_getpeersec_stream) (struct socket *sock, char *optval, int *o=
ptlen, unsigned len);
 int (*socket_getpeersec_dgram) (struct socket *sock, struct sk_buff *skb, =
u32 *secid);
 int (*sk_alloc_security) (struct sock *sk, int family, gfp_t priority);
 void (*sk_free_security) (struct sock *sk);
 void (*sk_clone_security) (const struct sock *sk, struct sock *newsk);
 void (*sk_getsecid) (struct sock *sk, u32 *secid);
 void (*sock_graft) (struct sock *sk, struct socket *parent);
 int (*inet_conn_request) (struct sock *sk, struct sk_buff *skb,
      struct request_sock *req);
 void (*inet_csk_clone) (struct sock *newsk, const struct request_sock *req=
);
 void (*inet_conn_established) (struct sock *sk, struct sk_buff *skb);
 int (*secmark_relabel_packet) (u32 secid);
 void (*secmark_refcount_inc) (void);
 void (*secmark_refcount_dec) (void);
 void (*req_classify_flow) (const struct request_sock *req, struct flowi *f=
l);
 int (*tun_dev_alloc_security) (void **security);
 void (*tun_dev_free_security) (void *security);
 int (*tun_dev_create) (void);
 int (*tun_dev_attach_queue) (void *security);
 int (*tun_dev_attach) (struct sock *sk, void *security);
 int (*tun_dev_open) (void *security);
 void (*skb_owned_by) (struct sk_buff *skb, struct sock *sk);
# 1696 "/usr/src/linux-2.6/include/linux/security.h"
 int (*key_alloc) (struct key *key, const struct cred *cred, unsigned long =
flags);
 void (*key_free) (struct key *key);
 int (*key_permission) (key_ref_t key_ref,
          const struct cred *cred,
          key_perm_t perm);
 int (*key_getsecurity)(struct key *key, char **_buffer);



 int (*audit_rule_init) (u32 field, u32 op, char *rulestr, void **lsmrule);
 int (*audit_rule_known) (struct audit_krule *krule);
 int (*audit_rule_match) (u32 secid, u32 field, u32 op, void *lsmrule,
     struct audit_context *actx);
 void (*audit_rule_free) (void *lsmrule);

};


extern int security_init(void);
extern int security_module_enable(struct security_operations *ops);
extern int register_security(struct security_operations *ops);
extern void __attribute__ ((__section__(".init.text"))) __attribute__((__co=
ld__)) __attribute__((no_instrument_function)) security_fixup_ops(struct se=
curity_operations *ops);



int security_ptrace_access_check(struct task_struct *child, unsigned int mo=
de);
int security_ptrace_traceme(struct task_struct *parent);
int security_capget(struct task_struct *target,
      kernel_cap_t *effective,
      kernel_cap_t *inheritable,
      kernel_cap_t *permitted);
int security_capset(struct cred *new, const struct cred *old,
      const kernel_cap_t *effective,
      const kernel_cap_t *inheritable,
      const kernel_cap_t *permitted);
int security_capable(const struct cred *cred, struct user_namespace *ns,
   int cap);
int security_capable_noaudit(const struct cred *cred, struct user_namespace=
 *ns,
        int cap);
int security_quotactl(int cmds, int type, int id, struct super_block *sb);
int security_quota_on(struct dentry *dentry);
int security_syslog(int type);
int security_settime(const struct timespec *ts, const struct timezone *tz);
int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
int security_bprm_set_creds(struct linux_binprm *bprm);
int security_bprm_check(struct linux_binprm *bprm);
void security_bprm_committing_creds(struct linux_binprm *bprm);
void security_bprm_committed_creds(struct linux_binprm *bprm);
int security_bprm_secureexec(struct linux_binprm *bprm);
int security_sb_alloc(struct super_block *sb);
void security_sb_free(struct super_block *sb);
int security_sb_copy_data(char *orig, char *copy);
int security_sb_remount(struct super_block *sb, void *data);
int security_sb_kern_mount(struct super_block *sb, int flags, void *data);
int security_sb_show_options(struct seq_file *m, struct super_block *sb);
int security_sb_statfs(struct dentry *dentry);
int security_sb_mount(const char *dev_name, struct path *path,
        const char *type, unsigned long flags, void *data);
int security_sb_umount(struct vfsmount *mnt, int flags);
int security_sb_pivotroot(struct path *old_path, struct path *new_path);
int security_sb_set_mnt_opts(struct super_block *sb,
    struct security_mnt_opts *opts,
    unsigned long kern_flags,
    unsigned long *set_kern_flags);
int security_sb_clone_mnt_opts(const struct super_block *oldsb,
    struct super_block *newsb);
int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opt=
s);
int security_dentry_init_security(struct dentry *dentry, int mode,
     struct qstr *name, void **ctx,
     u32 *ctxlen);

int security_inode_alloc(struct inode *inode);
void security_inode_free(struct inode *inode);
int security_inode_init_security(struct inode *inode, struct inode *dir,
     const struct qstr *qstr,
     initxattrs initxattrs, void *fs_data);
int security_old_inode_init_security(struct inode *inode, struct inode *dir,
         const struct qstr *qstr, const char **name,
         void **value, size_t *len);
int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t=
 mode);
int security_inode_link(struct dentry *old_dentry, struct inode *dir,
    struct dentry *new_dentry);
int security_inode_unlink(struct inode *dir, struct dentry *dentry);
int security_inode_symlink(struct inode *dir, struct dentry *dentry,
      const char *old_name);
int security_inode_mkdir(struct inode *dir, struct dentry *dentry, umode_t =
mode);
int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
int security_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t =
mode, dev_t dev);
int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
     struct inode *new_dir, struct dentry *new_dentry);
int security_inode_readlink(struct dentry *dentry);
int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
int security_inode_permission(struct inode *inode, int mask);
int security_inode_setattr(struct dentry *dentry, struct iattr *attr);
int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
int security_inode_setxattr(struct dentry *dentry, const char *name,
       const void *value, size_t size, int flags);
void security_inode_post_setxattr(struct dentry *dentry, const char *name,
      const void *value, size_t size, int flags);
int security_inode_getxattr(struct dentry *dentry, const char *name);
int security_inode_listxattr(struct dentry *dentry);
int security_inode_removexattr(struct dentry *dentry, const char *name);
int security_inode_need_killpriv(struct dentry *dentry);
int security_inode_killpriv(struct dentry *dentry);
int security_inode_getsecurity(const struct inode *inode, const char *name,=
 void **buffer, bool alloc);
int security_inode_setsecurity(struct inode *inode, const char *name, const=
 void *value, size_t size, int flags);
int security_inode_listsecurity(struct inode *inode, char *buffer, size_t b=
uffer_size);
void security_inode_getsecid(const struct inode *inode, u32 *secid);
int security_file_permission(struct file *file, int mask);
int security_file_alloc(struct file *file);
void security_file_free(struct file *file);
int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long =
arg);
int security_mmap_file(struct file *file, unsigned long prot,
   unsigned long flags);
int security_mmap_addr(unsigned long addr);
int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqpro=
t,
      unsigned long prot);
int security_file_lock(struct file *file, unsigned int cmd);
int security_file_fcntl(struct file *file, unsigned int cmd, unsigned long =
arg);
int security_file_set_fowner(struct file *file);
int security_file_send_sigiotask(struct task_struct *tsk,
     struct fown_struct *fown, int sig);
int security_file_receive(struct file *file);
int security_file_open(struct file *file, const struct cred *cred);
int security_task_create(unsigned long clone_flags);
void security_task_free(struct task_struct *task);
int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
void security_cred_free(struct cred *cred);
int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t =
gfp);
void security_transfer_creds(struct cred *new, const struct cred *old);
int security_kernel_act_as(struct cred *new, u32 secid);
int security_kernel_create_files_as(struct cred *new, struct inode *inode);
int security_kernel_module_request(char *kmod_name);
int security_kernel_module_from_file(struct file *file);
int security_task_fix_setuid(struct cred *new, const struct cred *old,
        int flags);
int security_task_setpgid(struct task_struct *p, pid_t pgid);
int security_task_getpgid(struct task_struct *p);
int security_task_getsid(struct task_struct *p);
void security_task_getsecid(struct task_struct *p, u32 *secid);
int security_task_setnice(struct task_struct *p, int nice);
int security_task_setioprio(struct task_struct *p, int ioprio);
int security_task_getioprio(struct task_struct *p);
int security_task_setrlimit(struct task_struct *p, unsigned int resource,
  struct rlimit *new_rlim);
int security_task_setscheduler(struct task_struct *p);
int security_task_getscheduler(struct task_struct *p);
int security_task_movememory(struct task_struct *p);
int security_task_kill(struct task_struct *p, struct siginfo *info,
   int sig, u32 secid);
int security_task_wait(struct task_struct *p);
int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
   unsigned long arg4, unsigned long arg5);
void security_task_to_inode(struct task_struct *p, struct inode *inode);
int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
int security_msg_msg_alloc(struct msg_msg *msg);
void security_msg_msg_free(struct msg_msg *msg);
int security_msg_queue_alloc(struct msg_queue *msq);
void security_msg_queue_free(struct msg_queue *msq);
int security_msg_queue_associate(struct msg_queue *msq, int msqflg);
int security_msg_queue_msgctl(struct msg_queue *msq, int cmd);
int security_msg_queue_msgsnd(struct msg_queue *msq,
         struct msg_msg *msg, int msqflg);
int security_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
         struct task_struct *target, long type, int mode);
int security_shm_alloc(struct shmid_kernel *shp);
void security_shm_free(struct shmid_kernel *shp);
int security_shm_associate(struct shmid_kernel *shp, int shmflg);
int security_shm_shmctl(struct shmid_kernel *shp, int cmd);
int security_shm_shmat(struct shmid_kernel *shp, char *shmaddr, int shmflg);
int security_sem_alloc(struct sem_array *sma);
void security_sem_free(struct sem_array *sma);
int security_sem_associate(struct sem_array *sma, int semflg);
int security_sem_semctl(struct sem_array *sma, int cmd);
int security_sem_semop(struct sem_array *sma, struct sembuf *sops,
   unsigned nsops, int alter);
void security_d_instantiate(struct dentry *dentry, struct inode *inode);
int security_getprocattr(struct task_struct *p, char *name, char **value);
int security_setprocattr(struct task_struct *p, char *name, void *value, si=
ze_t size);
int security_netlink_send(struct sock *sk, struct sk_buff *skb);
int security_ismaclabel(const char *name);
int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
void security_release_secctx(char *secdata, u32 seclen);

int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
# 2607 "/usr/src/linux-2.6/include/linux/security.h"
int security_unix_stream_connect(struct sock *sock, struct sock *other, str=
uct sock *newsk);
int security_unix_may_send(struct socket *sock, struct socket *other);
int security_socket_create(int family, int type, int protocol, int kern);
int security_socket_post_create(struct socket *sock, int family,
    int type, int protocol, int kern);
int security_socket_bind(struct socket *sock, struct sockaddr *address, int=
 addrlen);
int security_socket_connect(struct socket *sock, struct sockaddr *address, =
int addrlen);
int security_socket_listen(struct socket *sock, int backlog);
int security_socket_accept(struct socket *sock, struct socket *newsock);
int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int si=
ze);
int security_socket_recvmsg(struct socket *sock, struct msghdr *msg,
       int size, int flags);
int security_socket_getsockname(struct socket *sock);
int security_socket_getpeername(struct socket *sock);
int security_socket_getsockopt(struct socket *sock, int level, int optname);
int security_socket_setsockopt(struct socket *sock, int level, int optname);
int security_socket_shutdown(struct socket *sock, int how);
int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
int security_socket_getpeersec_stream(struct socket *sock, char *optval,
          int *optlen, unsigned len);
int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *s=
kb, u32 *secid);
int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
void security_sk_free(struct sock *sk);
void security_sk_clone(const struct sock *sk, struct sock *newsk);
void security_sk_classify_flow(struct sock *sk, struct flowi *fl);
void security_req_classify_flow(const struct request_sock *req, struct flow=
i *fl);
void security_sock_graft(struct sock*sk, struct socket *parent);
int security_inet_conn_request(struct sock *sk,
   struct sk_buff *skb, struct request_sock *req);
void security_inet_csk_clone(struct sock *newsk,
   const struct request_sock *req);
void security_inet_conn_established(struct sock *sk,
   struct sk_buff *skb);
int security_secmark_relabel_packet(u32 secid);
void security_secmark_refcount_inc(void);
void security_secmark_refcount_dec(void);
int security_tun_dev_alloc_security(void **security);
void security_tun_dev_free_security(void *security);
int security_tun_dev_create(void);
int security_tun_dev_attach_queue(void *security);
int security_tun_dev_attach(struct sock *sk, void *security);
int security_tun_dev_open(void *security);

void security_skb_owned_by(struct sk_buff *skb, struct sock *sk);
# 2870 "/usr/src/linux-2.6/include/linux/security.h"
static inline __attribute__((no_instrument_function)) int security_xfrm_pol=
icy_alloc(struct xfrm_sec_ctx **ctxp, struct xfrm_user_sec_ctx *sec_ctx)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_xfrm_pol=
icy_clone(struct xfrm_sec_ctx *old, struct xfrm_sec_ctx **new_ctxp)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) void security_xfrm_po=
licy_free(struct xfrm_sec_ctx *ctx)
{
}

static inline __attribute__((no_instrument_function)) int security_xfrm_pol=
icy_delete(struct xfrm_sec_ctx *ctx)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_xfrm_sta=
te_alloc(struct xfrm_state *x,
     struct xfrm_user_sec_ctx *sec_ctx)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_xfrm_sta=
te_alloc_acquire(struct xfrm_state *x,
     struct xfrm_sec_ctx *polsec, u32 secid)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) void security_xfrm_st=
ate_free(struct xfrm_state *x)
{
}

static inline __attribute__((no_instrument_function)) int security_xfrm_sta=
te_delete(struct xfrm_state *x)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_xfrm_pol=
icy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_xfrm_sta=
te_pol_flow_match(struct xfrm_state *x,
   struct xfrm_policy *xp, const struct flowi *fl)
{
 return 1;
}

static inline __attribute__((no_instrument_function)) int security_xfrm_dec=
ode_session(struct sk_buff *skb, u32 *secid)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) void security_skb_cla=
ssify_flow(struct sk_buff *skb, struct flowi *fl)
{
}
# 2949 "/usr/src/linux-2.6/include/linux/security.h"
static inline __attribute__((no_instrument_function)) int security_path_unl=
ink(struct path *dir, struct dentry *dentry)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_mkd=
ir(struct path *dir, struct dentry *dentry,
          umode_t mode)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_rmd=
ir(struct path *dir, struct dentry *dentry)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_mkn=
od(struct path *dir, struct dentry *dentry,
          umode_t mode, unsigned int dev)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_tru=
ncate(struct path *path)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_sym=
link(struct path *dir, struct dentry *dentry,
     const char *old_name)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_lin=
k(struct dentry *old_dentry,
         struct path *new_dir,
         struct dentry *new_dentry)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_ren=
ame(struct path *old_dir,
           struct dentry *old_dentry,
           struct path *new_dir,
           struct dentry *new_dentry)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_chm=
od(struct path *path, umode_t mode)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_cho=
wn(struct path *path, kuid_t uid, kgid_t gid)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int security_path_chr=
oot(struct path *path)
{
 return 0;
}





int security_key_alloc(struct key *key, const struct cred *cred, unsigned l=
ong flags);
void security_key_free(struct key *key);
int security_key_permission(key_ref_t key_ref,
       const struct cred *cred, key_perm_t perm);
int security_key_getsecurity(struct key *key, char **_buffer);
# 3053 "/usr/src/linux-2.6/include/linux/security.h"
int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmru=
le);
int security_audit_rule_known(struct audit_krule *krule);
int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
         struct audit_context *actx);
void security_audit_rule_free(void *lsmrule);
# 3094 "/usr/src/linux-2.6/include/linux/security.h"
static inline __attribute__((no_instrument_function)) struct dentry *securi=
tyfs_create_dir(const char *name,
         struct dentry *parent)
{
 return ERR_PTR(-19);
}

static inline __attribute__((no_instrument_function)) struct dentry *securi=
tyfs_create_file(const char *name,
          umode_t mode,
          struct dentry *parent,
          void *data,
          const struct file_operations *fops)
{
 return ERR_PTR(-19);
}

static inline __attribute__((no_instrument_function)) void securityfs_remov=
e(struct dentry *dentry)
{}





static inline __attribute__((no_instrument_function)) char *alloc_secdata(v=
oid)
{
 return (char *)get_zeroed_page(((( gfp_t)0x10u) | (( gfp_t)0x40u) | (( gfp=
_t)0x80u)));
}

static inline __attribute__((no_instrument_function)) void free_secdata(voi=
d *secdata)
{
 free_pages(((unsigned long)secdata), 0);
}
# 3145 "/usr/src/linux-2.6/include/linux/security.h"
static inline __attribute__((no_instrument_function)) int yama_ptrace_acces=
s_check(struct task_struct *child,
        unsigned int mode)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) int yama_ptrace_trace=
me(struct task_struct *parent)
{
 return 0;
}

static inline __attribute__((no_instrument_function)) void yama_task_free(s=
truct task_struct *task)
{
}

static inline __attribute__((no_instrument_function)) int yama_task_prctl(i=
nt option, unsigned long arg2,
      unsigned long arg3, unsigned long arg4,
      unsigned long arg5)
{
 return -38;
}
# 52 "/usr/src/linux-2.6/include/linux/tracehook.h" 2

struct linux_binprm;




static inline __attribute__((no_instrument_function)) int ptrace_report_sys=
call(struct pt_regs *regs)
{
 int ptrace =3D get_current()->ptrace;

 if (!(ptrace & 0x00000001))
  return 0;

 ptrace_notify(5 | ((ptrace & (1 << (3 + (0)))) ? 0x80 : 0));






 if (get_current()->exit_code) {
  send_sig(get_current()->exit_code, get_current(), 1);
  get_current()->exit_code =3D 0;
 }

 return fatal_signal_pending(get_current());
}
# 99 "/usr/src/linux-2.6/include/linux/tracehook.h"
static inline __attribute__((no_instrument_function)) __attribute__((warn_u=
nused_result)) int tracehook_report_syscall_entry(
 struct pt_regs *regs)
{
 return ptrace_report_syscall(regs);
}
# 122 "/usr/src/linux-2.6/include/linux/tracehook.h"
static inline __attribute__((no_instrument_function)) void tracehook_report=
_syscall_exit(struct pt_regs *regs, int step)
{
 if (step) {
  siginfo_t info;
  user_single_step_siginfo(get_current(), regs, &info);
  force_sig_info(5, &info, get_current());
  return;
 }

 ptrace_report_syscall(regs);
}
# 149 "/usr/src/linux-2.6/include/linux/tracehook.h"
static inline __attribute__((no_instrument_function)) void tracehook_signal=
_handler(int sig, siginfo_t *info,
         const struct k_sigaction *ka,
         struct pt_regs *regs, int stepping)
{
 if (stepping)
  ptrace_notify(5);
}
# 166 "/usr/src/linux-2.6/include/linux/tracehook.h"
static inline __attribute__((no_instrument_function)) void set_notify_resum=
e(struct task_struct *task)
{

 if (!test_and_set_tsk_thread_flag(task, 1))
  kick_process(task);

}
# 187 "/usr/src/linux-2.6/include/linux/tracehook.h"
static inline __attribute__((no_instrument_function)) void tracehook_notify=
_resume(struct pt_regs *regs)
{





 __asm__ __volatile__("": : :"memory");
 if (__builtin_expect(!!(get_current()->task_works), 0))
  task_work_run();
}
# 4 "/usr/src/linux-2.6/kernel/task_work.c" 2

static struct callback_head work_exited;
# 24 "/usr/src/linux-2.6/kernel/task_work.c"
int
task_work_add(struct task_struct *task, struct callback_head *work, bool no=
tify)
{
 struct callback_head *head;

 do {
  head =3D (*(volatile typeof(task->task_works) *)&(task->task_works));
  if (__builtin_expect(!!(head =3D=3D &work_exited), 0))
   return -3;
  work->next =3D head;
 } while (({ __typeof__(*((&task->task_works))) __ret; __typeof__(*((&task-=
>task_works))) __old =3D ((head)); __typeof__(*((&task->task_works))) __new=
 =3D ((work)); switch ((sizeof(*(&task->task_works)))) { case 1: { volatile=
 u8 *__ptr =3D (volatile u8 *)((&task->task_works)); asm volatile("" "cmpxc=
hgb %2,%1" : "=3Da" (__ret), "+m" (*__ptr) : "q" (__new), "0" (__old) : "me=
mory"); break; } case 2: { volatile u16 *__ptr =3D (volatile u16 *)((&task-=
>task_works)); asm volatile("" "cmpxchgw %2,%1" : "=3Da" (__ret), "+m" (*__=
ptr) : "r" (__new), "0" (__old) : "memory"); break; } case 4: { volatile u3=
2 *__ptr =3D (volatile u32 *)((&task->task_works)); asm volatile("" "cmpxch=
gl %2,%1" : "=3Da" (__ret), "+m" (*__ptr) : "r" (__new), "0" (__old) : "mem=
ory"); break; } case -1: { volatile u64 *__ptr =3D (volatile u64 *)((&task-=
>task_works)); asm volatile("" "cmpxchgq %2,%1" : "=3Da" (__ret), "+m" (*__=
ptr) : "r" (__new), "0" (__old) : "memory"); break; } default: __cmpxchg_wr=
ong_size(); } __ret; }) !=3D head);

 if (notify)
  set_notify_resume(task);
 return 0;
}
# 52 "/usr/src/linux-2.6/kernel/task_work.c"
struct callback_head *
task_work_cancel(struct task_struct *task, task_work_func_t func)
{
 struct callback_head **pprev =3D &task->task_works;
 struct callback_head *work;
 unsigned long flags;






 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); do { do { do { ({ unsigned long __dummy; typeof(flag=
s) __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); flags =3D arch_local=
_irq_save(); } while (0); do { } while (0); } while (0); do { __asm__ __vol=
atile__("": : :"memory"); (void)0; (void)(&task->pi_lock); } while (0); } w=
hile (0); } while (0);
 while ((work =3D (*(volatile typeof(*pprev) *)&(*pprev)))) {
  do { } while (0);
  if (work->func !=3D func)
   pprev =3D &work->next;
  else if (({ __typeof__(*((pprev))) __ret; __typeof__(*((pprev))) __old =
=3D ((work)); __typeof__(*((pprev))) __new =3D ((work->next)); switch ((siz=
eof(*(pprev)))) { case 1: { volatile u8 *__ptr =3D (volatile u8 *)((pprev))=
; asm volatile("" "cmpxchgb %2,%1" : "=3Da" (__ret), "+m" (*__ptr) : "q" (_=
_new), "0" (__old) : "memory"); break; } case 2: { volatile u16 *__ptr =3D =
(volatile u16 *)((pprev)); asm volatile("" "cmpxchgw %2,%1" : "=3Da" (__ret=
), "+m" (*__ptr) : "r" (__new), "0" (__old) : "memory"); break; } case 4: {=
 volatile u32 *__ptr =3D (volatile u32 *)((pprev)); asm volatile("" "cmpxch=
gl %2,%1" : "=3Da" (__ret), "+m" (*__ptr) : "r" (__new), "0" (__old) : "mem=
ory"); break; } case -1: { volatile u64 *__ptr =3D (volatile u64 *)((pprev)=
); asm volatile("" "cmpxchgq %2,%1" : "=3Da" (__ret), "+m" (*__ptr) : "r" (=
__new), "0" (__old) : "memory"); break; } default: __cmpxchg_wrong_size(); =
} __ret; }) =3D=3D work)
   break;
 }
 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); do { do { if (({ ({ unsigned long __dummy; typeof(fl=
ags) __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; }); arch_irqs_disabled=
_flags(flags); })) { do { ({ unsigned long __dummy; typeof(flags) __dummy2;=
 (void)(&__dummy =3D=3D &__dummy2); 1; }); arch_local_irq_restore(flags); }=
 while (0); do { } while (0); } else { do { } while (0); do { ({ unsigned l=
ong __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=3D &__dummy2); 1; =
}); arch_local_irq_restore(flags); } while (0); } } while (0); do { __asm__=
 __volatile__("": : :"memory"); (void)0; (void)(&task->pi_lock); } while (0=
); } while (0); } while (0);

 return work;
}
# 85 "/usr/src/linux-2.6/kernel/task_work.c"
void task_work_run(void)
{
 struct task_struct *task =3D get_current();
 struct callback_head *work, *head, *next;

 for (;;) {




  do {
   work =3D (*(volatile typeof(task->task_works) *)&(task->task_works));
   head =3D !work && (task->flags & 0x00000004) ?
    &work_exited : ((void *)0);
  } while (({ __typeof__(*((&task->task_works))) __ret; __typeof__(*((&task=
->task_works))) __old =3D ((work)); __typeof__(*((&task->task_works))) __ne=
w =3D ((head)); switch ((sizeof(*(&task->task_works)))) { case 1: { volatil=
e u8 *__ptr =3D (volatile u8 *)((&task->task_works)); asm volatile("" "cmpx=
chgb %2,%1" : "=3Da" (__ret), "+m" (*__ptr) : "q" (__new), "0" (__old) : "m=
emory"); break; } case 2: { volatile u16 *__ptr =3D (volatile u16 *)((&task=
->task_works)); asm volatile("" "cmpxchgw %2,%1" : "=3Da" (__ret), "+m" (*_=
_ptr) : "r" (__new), "0" (__old) : "memory"); break; } case 4: { volatile u=
32 *__ptr =3D (volatile u32 *)((&task->task_works)); asm volatile("" "cmpxc=
hgl %2,%1" : "=3Da" (__ret), "+m" (*__ptr) : "r" (__new), "0" (__old) : "me=
mory"); break; } case -1: { volatile u64 *__ptr =3D (volatile u64 *)((&task=
->task_works)); asm volatile("" "cmpxchgq %2,%1" : "=3Da" (__ret), "+m" (*_=
_ptr) : "r" (__new), "0" (__old) : "memory"); break; } default: __cmpxchg_w=
rong_size(); } __ret; }) !=3D work);

  if (!work)
   break;





  do { cpu_relax(); } while (((void)(&(&task->pi_lock)->raw_lock), 0));
  __asm__ __volatile__("": : :"memory");


  head =3D ((void *)0);
  do {
   next =3D work->next;
   work->next =3D head;
   head =3D work;
   work =3D next;
  } while (work);

  work =3D head;
  do {
   next =3D work->next;
   work->func(work);
   work =3D next;
   ({ __might_sleep("/usr/src/linux-2.6/kernel/task_work.c", 125, 0); _cond=
_resched(); });
  } while (work);
 }
}

--J2SCkAp4GZ/dPZZf--

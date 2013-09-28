Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3I1Xl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:41:59 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58356 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab3I1Xl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:41:57 -0400
MIME-Version: 1.0
In-Reply-To: <1380411144-9236-11-git-send-email-geyslan@gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
	<1380411144-9236-11-git-send-email-geyslan@gmail.com>
Date: Sat, 28 Sep 2013 20:41:56 -0300
Message-ID: <CAGG-pUS8A4Le+atvB7uwnMRv7fsjjQTYnpfRLd3PbkoM1wOwaQ@mail.gmail.com>
Subject: Re: [PATCH] fs: exec.c: Coding style sanitization
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, disconsider this e-mail.

Geyslan Gregório Bem
hackingbits.com


2013/9/28 Geyslan G. Bem <geyslan@gmail.com>:
> Adjustment based on the checkpatch.pl.
>
> Tested.
>
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/exec.c | 92 ++++++++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 49 insertions(+), 43 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 8875dd1..b5c6086 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -19,7 +19,7 @@
>   * current->executable is only used by the procfs.  This allows a dispatch
>   * table to check for several different types  of binary formats.  We keep
>   * trying until we recognize the file or we run out of supported binary
> - * formats.
> + * formats.
>   */
>
>  #include <linux/slab.h>
> @@ -55,8 +55,8 @@
>  #include <linux/pipe_fs_i.h>
>  #include <linux/oom.h>
>  #include <linux/compat.h>
> +#include <linux/uaccess.h>
>
> -#include <asm/uaccess.h>
>  #include <asm/mmu_context.h>
>  #include <asm/tlb.h>
>
> @@ -71,7 +71,7 @@ int suid_dumpable = 0;
>  static LIST_HEAD(formats);
>  static DEFINE_RWLOCK(binfmt_lock);
>
> -void __register_binfmt(struct linux_binfmt * fmt, int insert)
> +void __register_binfmt(struct linux_binfmt *fmt, int insert)
>  {
>         BUG_ON(!fmt);
>         if (WARN_ON(!fmt->load_binary))
> @@ -81,19 +81,17 @@ void __register_binfmt(struct linux_binfmt * fmt, int insert)
>                  list_add_tail(&fmt->lh, &formats);
>         write_unlock(&binfmt_lock);
>  }
> -
>  EXPORT_SYMBOL(__register_binfmt);
>
> -void unregister_binfmt(struct linux_binfmt * fmt)
> +void unregister_binfmt(struct linux_binfmt *fmt)
>  {
>         write_lock(&binfmt_lock);
>         list_del(&fmt->lh);
>         write_unlock(&binfmt_lock);
>  }
> -
>  EXPORT_SYMBOL(unregister_binfmt);
>
> -static inline void put_binfmt(struct linux_binfmt * fmt)
> +static inline void put_binfmt(struct linux_binfmt *fmt)
>  {
>         module_put(fmt->module);
>  }
> @@ -136,8 +134,8 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
>         fsnotify_open(file);
>
>         error = -ENOEXEC;
> -       if(file->f_op) {
> -               struct linux_binfmt * fmt;
> +       if (file->f_op) {
> +               struct linux_binfmt *fmt;
>
>                 read_lock(&binfmt_lock);
>                 list_for_each_entry(fmt, &formats, lh) {
> @@ -154,10 +152,11 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
>                 }
>                 read_unlock(&binfmt_lock);
>         }
> +
>  exit:
>         fput(file);
>  out:
> -       return error;
> +       return error;
>  }
>
>  #ifdef CONFIG_MMU
> @@ -180,7 +179,7 @@ static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
>  }
>
>  static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
> -               int write)
> +                                int write)
>  {
>         struct page *page;
>         int ret;
> @@ -241,7 +240,7 @@ static void free_arg_pages(struct linux_binprm *bprm)
>  }
>
>  static void flush_arg_page(struct linux_binprm *bprm, unsigned long pos,
> -               struct page *page)
> +                          struct page *page)
>  {
>         flush_cache_page(bprm->vma, pos, page_to_pfn(page));
>  }
> @@ -268,7 +267,9 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
>         BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
>         vma->vm_end = STACK_TOP_MAX;
>         vma->vm_start = vma->vm_end - PAGE_SIZE;
> -       vma->vm_flags = VM_SOFTDIRTY | VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
> +       vma->vm_flags = (VM_SOFTDIRTY |
> +                        VM_STACK_FLAGS |
> +                        VM_STACK_INCOMPLETE_SETUP);
>         vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
>         INIT_LIST_HEAD(&vma->anon_vma_chain);
>
> @@ -299,7 +300,7 @@ static inline void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
>  }
>
>  static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
> -               int write)
> +                                int write)
>  {
>         struct page *page;
>
> @@ -335,7 +336,7 @@ static void free_arg_pages(struct linux_binprm *bprm)
>  }
>
>  static void flush_arg_page(struct linux_binprm *bprm, unsigned long pos,
> -               struct page *page)
> +                          struct page *page)
>  {
>  }
>
> @@ -616,7 +617,9 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
>                  * when the old and new regions overlap clear from new_end.
>                  */
>                 free_pgd_range(&tlb, new_end, old_end, new_end,
> -                       vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
> +                              vma->vm_next
> +                              ? vma->vm_next->vm_start
> +                              : USER_PGTABLES_CEILING);
>         } else {
>                 /*
>                  * otherwise, clean from old_start; this is done to not touch
> @@ -625,7 +628,9 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
>                  * for the others its just a little faster.
>                  */
>                 free_pgd_range(&tlb, old_start, old_end, new_end,
> -                       vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
> +                              vma->vm_next
> +                              ? vma->vm_next->vm_start
> +                              : USER_PGTABLES_CEILING);
>         }
>         tlb_finish_mmu(&tlb, old_start, old_end);
>
> @@ -803,7 +808,6 @@ int kernel_read(struct file *file, loff_t offset,
>         set_fs(old_fs);
>         return result;
>  }
> -
>  EXPORT_SYMBOL(kernel_read);
>
>  ssize_t read_code(struct file *file, unsigned long addr, loff_t pos, size_t len)
> @@ -818,7 +822,7 @@ EXPORT_SYMBOL(read_code);
>  static int exec_mmap(struct mm_struct *mm)
>  {
>         struct task_struct *tsk;
> -       struct mm_struct * old_mm, *active_mm;
> +       struct mm_struct *old_mm, *active_mm;
>
>         /* Notify parent that we're no longer interested in the old VM */
>         tsk = current;
> @@ -1064,7 +1068,7 @@ static void filename_to_taskname(char *tcomm, const char *fn, unsigned int len)
>         tcomm[i] = '\0';
>  }
>
> -int flush_old_exec(struct linux_binprm * bprm)
> +int flush_old_exec(struct linux_binprm *bprm)
>  {
>         int retval;
>
> @@ -1109,14 +1113,15 @@ void would_dump(struct linux_binprm *bprm, struct file *file)
>  }
>  EXPORT_SYMBOL(would_dump);
>
> -void setup_new_exec(struct linux_binprm * bprm)
> +void setup_new_exec(struct linux_binprm *bprm)
>  {
>         arch_pick_mmap_layout(current->mm);
>
>         /* This is the point of no return */
>         current->sas_ss_sp = current->sas_ss_size = 0;
>
> -       if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
> +       if (uid_eq(current_euid(), current_uid()) &&
> +           gid_eq(current_egid(), current_gid()))
>                 set_dumpable(current->mm, SUID_DUMP_USER);
>         else
>                 set_dumpable(current->mm, suid_dumpable);
> @@ -1143,7 +1148,7 @@ void setup_new_exec(struct linux_binprm * bprm)
>            group */
>
>         current->self_exec_id++;
> -
> +
>         flush_signal_handlers(current, 0);
>         do_close_on_exec(current->files);
>  }
> @@ -1269,8 +1274,8 @@ static int check_unsafe_exec(struct linux_binprm *bprm)
>         return res;
>  }
>
> -/*
> - * Fill the binprm structure from the inode.
> +/*
> + * Fill the binprm structure from the inode.
>   * Check permissions, then read the first 128 (BINPRM_BUF_SIZE) bytes
>   *
>   * This may be called multiple times for binary chains (scripts for example).
> @@ -1278,7 +1283,7 @@ static int check_unsafe_exec(struct linux_binprm *bprm)
>  int prepare_binprm(struct linux_binprm *bprm)
>  {
>         umode_t mode;
> -       struct inode * inode = file_inode(bprm->file);
> +       struct inode *inode = file_inode(bprm->file);
>         int retval;
>
>         mode = inode->i_mode;
> @@ -1320,7 +1325,6 @@ int prepare_binprm(struct linux_binprm *bprm)
>         memset(bprm->buf, 0, BINPRM_BUF_SIZE);
>         return kernel_read(bprm->file, 0, bprm->buf, BINPRM_BUF_SIZE);
>  }
> -
>  EXPORT_SYMBOL(prepare_binprm);
>
>  /*
> @@ -1367,7 +1371,9 @@ out:
>  }
>  EXPORT_SYMBOL(remove_arg_zero);
>
> -#define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
> +#define printable(c) (((c) == '\t') ||                 \
> +                     ((c) == '\n') ||                  \
> +                     (0x20 <= (c) && (c) <= 0x7e))
>  /*
>   * cycle the list of binary formats handler, until one recognizes the image
>   */
> @@ -1413,7 +1419,8 @@ int search_binary_handler(struct linux_binprm *bprm)
>                 if (printable(bprm->buf[0]) && printable(bprm->buf[1]) &&
>                     printable(bprm->buf[2]) && printable(bprm->buf[3]))
>                         return retval;
> -               if (request_module("binfmt-%04x", *(ushort *)(bprm->buf + 2)) < 0)
> +               if (request_module("binfmt-%04x",
> +                                  *(ushort *)(bprm->buf + 2)) < 0)
>                         return retval;
>                 need_retry = false;
>                 goto retry;
> @@ -1455,8 +1462,8 @@ static int exec_binprm(struct linux_binprm *bprm)
>   * sys_execve() executes a new program.
>   */
>  static int do_execve_common(const char *filename,
> -                               struct user_arg_ptr argv,
> -                               struct user_arg_ptr envp)
> +                           struct user_arg_ptr argv,
> +                           struct user_arg_ptr envp)
>  {
>         struct linux_binprm *bprm;
>         struct file *file;
> @@ -1514,12 +1521,12 @@ static int do_execve_common(const char *filename,
>         if (retval)
>                 goto out_file;
>
> -       bprm->argc = count(argv, MAX_ARG_STRINGS);
> -       if ((retval = bprm->argc) < 0)
> +       retval = bprm->argc = count(argv, MAX_ARG_STRINGS);
> +       if (retval < 0)
>                 goto out;
>
> -       bprm->envc = count(envp, MAX_ARG_STRINGS);
> -       if ((retval = bprm->envc) < 0)
> +       retval = bprm->envc = count(envp, MAX_ARG_STRINGS);
> +       if (retval < 0)
>                 goto out;
>
>         retval = prepare_binprm(bprm);
> @@ -1580,8 +1587,8 @@ out_ret:
>  }
>
>  int do_execve(const char *filename,
> -       const char __user *const __user *__argv,
> -       const char __user *const __user *__envp)
> +             const char __user *const __user *__argv,
> +             const char __user *const __user *__envp)
>  {
>         struct user_arg_ptr argv = { .ptr.native = __argv };
>         struct user_arg_ptr envp = { .ptr.native = __envp };
> @@ -1590,8 +1597,8 @@ int do_execve(const char *filename,
>
>  #ifdef CONFIG_COMPAT
>  static int compat_do_execve(const char *filename,
> -       const compat_uptr_t __user *__argv,
> -       const compat_uptr_t __user *__envp)
> +                           const compat_uptr_t __user *__argv,
> +                           const compat_uptr_t __user *__envp)
>  {
>         struct user_arg_ptr argv = {
>                 .is_compat = true,
> @@ -1616,7 +1623,6 @@ void set_binfmt(struct linux_binfmt *new)
>         if (new)
>                 __module_get(new->module);
>  }
> -
>  EXPORT_SYMBOL(set_binfmt);
>
>  /*
> @@ -1687,9 +1693,9 @@ SYSCALL_DEFINE3(execve,
>         return error;
>  }
>  #ifdef CONFIG_COMPAT
> -asmlinkage long compat_sys_execve(const char __user * filename,
> -       const compat_uptr_t __user * argv,
> -       const compat_uptr_t __user * envp)
> +asmlinkage long compat_sys_execve(const char __user *filename,
> +                                 const compat_uptr_t __user *argv,
> +                                 const compat_uptr_t __user *envp)
>  {
>         struct filename *path = getname(filename);
>         int error = PTR_ERR(path);
> --
> 1.8.4
>

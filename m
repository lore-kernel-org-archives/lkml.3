Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab3JZFRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 01:17:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61048 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3JZFRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 01:17:40 -0400
Message-ID: <1382764655.5820.29.camel@marge.simpson.net>
Subject: nouveau: explosion in nouveau_fence_signal()
From: Mike Galbraith <bitbucket@online.de>
To: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 26 Oct 2013 07:17:35 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:I/7lcLK7ufsfpNa2/jve3yj2k8bB8/N6OufjEozk8bT
 EPv/n7bHZp/bL6TdUy9OlBJJu8hG92BSpKZYjpCpcIOWhZvn2+
 lLJ+BkfIj8LE0xedIm9QV3VkFpUxf70DeZuiyoQLLIhw+FJPG2
 l5Qzx5bP5lmBnxxGMwm6lqm8gEY1zIp+z/b+Rgvyjv3EnZR7AX
 fshE1SRZNipUKLjdAOOCe6GjPRLfWeo/9C1TtkBBs3oETwWB3f
 aJa1+BTZHZkDelWX9X/RT/HSMK6mbX9m5AX6a2ajA5ZuvTMcZt
 ci9dr0VLWqv4TB3cRIK4D2NGPsZaD0SdBLeC+b1/BtbCNnNoGN
 XvzaPMX5Vg1fD/gF+fazIYXatHNdgm9R48ZT/AQbJEu+ClnNbe
 V9VaaAbamo09w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12.0-rt1 only exists here, so add a pile of salt.  Kernel seems stable
though, first sign of troubles was when I decided to see if nouveau
rendering speed has improved since last time I tried it (ages ago), so
I'll post the crash just in case.

I didn't get to check rendering speed..

[    56.529] (EE) Failed to initialize GLX extension (Compatible NVIDIA X driver not found)

..hohum, back to plain ole nv.

crash> bt 
PID: 8580   TASK: ffff88021a3998a0  CPU: 0   COMMAND: "Xorg"
 #0 [ffff88003731d7e0] machine_kexec at ffffffff8103a361
 #1 [ffff88003731d840] crash_kexec at ffffffff810d1763
 #2 [ffff88003731d910] oops_end at ffffffff815e8da8
 #3 [ffff88003731d940] no_context at ffffffff815d1ad4
 #4 [ffff88003731d990] __bad_area_nosemaphore at ffffffff815d1cb8
 #5 [ffff88003731d9f0] bad_area at ffffffff815d1d2a
 #6 [ffff88003731da20] __do_page_fault at ffffffff815eb566
 #7 [ffff88003731db40] do_page_fault at ffffffff815eb699
 #8 [ffff88003731db50] page_fault at ffffffff815e81c8
    [exception RIP: nouveau_fence_signal+102]
    RIP: ffffffffa0439356  RSP: ffff88003731dc08  RFLAGS: 00010246
    RAX: 002e0201003602b2  RBX: ffff88007985a3c0  RCX: dead000000100100
    RDX: 0000000000000000  RSI: dead000000200200  RDI: 0000000000000001
    RBP: ffff88003731dc28   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000001  R11: 0000000000000246  R12: ffff88007985aa30
    R13: ffff88007985aa50  R14: ffff88007985aa40  R15: ffff8802221f7c48
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #9 [ffff88003731dc30] nouveau_fence_done at ffffffffa04395e5 [nouveau]
#10 [ffff88003731dc80] nouveau_fence_work at ffffffffa0439c1e [nouveau]
#11 [ffff88003731dcc0] nouveau_gem_object_unmap at ffffffffa043e911 [nouveau]
#12 [ffff88003731dd00] nouveau_gem_object_close at ffffffffa043fd6b [nouveau]
#13 [ffff88003731dd20] drm_gem_handle_delete at ffffffffa0198f7a [drm]
#14 [ffff88003731dd70] drm_gem_close_ioctl at ffffffffa01992d3 [drm]
#15 [ffff88003731dd80] drm_ioctl at ffffffffa0196eca [drm]
#16 [ffff88003731dea0] nouveau_drm_ioctl at ffffffffa0437f3e [nouveau]
#17 [ffff88003731dee0] do_vfs_ioctl at ffffffff811b1955
#18 [ffff88003731df20] sys_ioctl at ffffffff811b1c41
#19 [ffff88003731df80] system_call_fastpath at ffffffff815ef5f9
    RIP: 00007f5cd3b0d837  RSP: 00007ffff73ccd70  RFLAGS: 00003202
    RAX: 0000000000000010  RBX: ffffffff815ef5f9  RCX: 0000000000000001
    RDX: 00007ffff73ccaf0  RSI: 0000000040086409  RDI: 000000000000000a
    RBP: 0000000040086409   R8: 000000000000032b   R9: 00000000414b0000
    R10: 0000000000000001  R11: 0000000000003246  R12: 0000000001463f00
    R13: 0000000000000000  R14: 0000000001463f18  R15: 000000000000000a
    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b
crash> mod -s nouveau
     MODULE       NAME                     SIZE  OBJECT FILE
ffffffffa04a3f00  nouveau                965202  /lib/modules/3.12.0-rt1/kernel/drivers/gpu/drm/nouveau/nouveau.ko
crash> gdb list *nouveau_fence_signal+102
0xffffffffa0439356 is in nouveau_fence_signal (include/linux/list.h:88).
83       * This is only for internal list manipulation where we know
84       * the prev/next entries already!
85       */
86      static inline void __list_del(struct list_head * prev, struct list_head * next)
87      {
88              next->prev = prev;
89              prev->next = next;
90      }
91      
92      /**
crash> gdb list *nouveau_fence_signal+50
0xffffffffa0439322 is in nouveau_fence_signal (drivers/gpu/drm/nouveau/nouveau_fence.c:50).
45      static void
46      nouveau_fence_signal(struct nouveau_fence *fence)
47      {
48              struct fence_work *work, *temp;
49      
50              list_for_each_entry_safe(work, temp, &fence->work, head) {
51                      schedule_work(&work->base);
52                      list_del(&work->head);
53              }
54      
crash> gdb list *0xffffffffa04395e5
0xffffffffa04395e5 is in nouveau_fence_done (drivers/gpu/drm/nouveau/nouveau_fence.c:134).
129             list_for_each_entry_safe(fence, fnext, &fctx->pending, head) {
130                     if (fctx->read(chan) < fence->sequence)
131                             break;
132     
133                     nouveau_fence_signal(fence);
134                     nouveau_fence_unref(&fence);
135             }
136             spin_unlock(&fctx->lock);
137     }
138     
crash>


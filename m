Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3IWGFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:05:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:31223 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3IWGFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:05:36 -0400
X-Spam-Score: -100.4
Message-ID: <523FD9E7.3050303@asianux.com>
Date: Mon, 23 Sep 2013 14:04:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] arc: compiler: bug: about an arc compiler's bug which
 is not in gcc main source code.
Content-Type: multipart/mixed;
 boundary="------------000508040008000408060905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000508040008000408060905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello arc members:

It is arc compiler's bug, but can not report to gnu tool chain (it is
not integrated into gnu tool chain), so have to report it here (I find
this bug here, and I guess, some arc folks are here, too).


In "drivers/power/wm831x_power.c", all wm831x_bat_get_prop() calling
functions are inline, so wm831x_bat_get_prop() size is more than 256,
but it uses 1 byte to express related offset (".byte .L61-.L65 + 6").

If let some of wm831x_bat_get_prop() calling functions noinline, it can
pass compiling.

The related .s file is in attachment, and the related command and error
(for next-20130920 tree) is below:

    /usr/local/bin/arc-elf32-gcc -Wp,-MD,drivers/power/.wm831x_power.o.d  -nostdinc -isystem /usr/local/lib/gcc/arc-elf32/4.4.7/include -I/root/linux-next/arch/arc/include -Iarch/arc/include/generated  -Iinclude -I/root/linux-next/arch/arc/include/uapi -Iarch/arc/include/generated/uapi -I/root/linux-next/include/uapi -Iinclude/generated/uapi -include /root/linux-next/include/linux/kconfig.h -include /root/linux-next/arch/arc/include/asm/current.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -mA7 -fno-common -pipe -fno-builtin -D__linux__ -fsection-anchors -mlock -mswape -mrtsc -fasynchronous-unwind-tables -mno-sdata -fcall-used-gp -mbig-endian -multcost=16 -fno-reorder-blocks -fno-ipa-cp-clone -Wframe-larger-than=1024 -fno-stack-protector -fomit-frame-pointer -g -femit-struct-debug-baseonly -fno-var-tracking -fno-inline-functions-cal
 led-once 
-Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -DDEBUG   -DMODULE -mlong-calls  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(wm831x_power)"  -D"KBUILD_MODNAME=KBUILD_STR(wm831x_power)" -c -o drivers/power/.tmp_wm831x_power.o drivers/power/wm831x_power.c
  {standard input}: Assembler messages:
  {standard input}:934: Error: value of 256 too large for field of 1 bytes at 1987


Welcome any suggestions or completions (e.g. which location and members
this bug should be reported to).

Thanks.
-- 
Chen Gang

--------------000508040008000408060905
Content-Type: text/plain; charset=UTF-8;
 name="wm831x_power.s"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wm831x_power.s"

	.file	"wm831x_power.c"
	.cpu ARC700
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section .text
.Ltext0:
	.section	.exit.text,"ax",@progbits
	.align 4
	.type	wm831x_power_driver_exit, @function
wm831x_power_driver_exit:
.LFB869:
.LSM0:
.LSM1:
	mov_s r0,@.LANCHOR0	;9
	j @platform_driver_unregister
.LFE869:
	.size	wm831x_power_driver_exit, .-wm831x_power_driver_exit
	.section .text
	.align 4
	.type	wm831x_power_remove, @function
wm831x_power_remove:
.LFB866:
.LM1:
	push_s blink
.LCFI0:
.LCFI1:
	bl.d __st_r13_to_r22
	sub_s sp,sp,40
.LM2:
	mov_s r14,r0	;0
.LBB165:
.LBB166:
.LM3:
	add_s r0,r0,12
	jl @dev_get_drvdata
.LBE166:
.LBE165:
.LM4:
	mov r16,@.LANCHOR1		;10
.LBB168:
.LBB167:
.LM5:
	mov_s r13,r0	;0
.LBE167:
.LBE168:
.LM6:
	ld_s r15,[r0]		;11
	mov r22,@platform_get_irq_byname		;10
	mov r21,@irq_create_mapping		;10
	mov r20,@free_irq		;10
.LM7:
	b_s @.L4
.L5:
.LM8:
	jl.d [r22]
	ld.ab r1,[r16,4]	;16
	mov_s r1,r0	;0
.LBB169:
.LBB170:
.LM9:
	jl.d [r21]
	ld_s r0,[r15,92]		;11
.LBE170:
.LBE169:
.LM10:
	jl.d [r20]
	mov_s r1,r13	;0
.L4:
.LM11:
	mov_s r0,r14	;0
	mov r19,@platform_get_irq_byname		;10
	mov r18,@irq_create_mapping		;10
	mov r17,@free_irq		;10
.LM12:
	brne r16, @.LANCHOR1+32, @.L5
.LM13:
	mov_s r1,@.LC0	;9
	jl [r19]
	mov_s r1,r0	;0
.LBB171:
.LBB172:
.LM14:
	jl.d [r18]
	ld_s r0,[r15,92]		;11
.LBE172:
.LBE171:
.LM15:
	jl.d [r17]
	mov_s r1,r13	;0
.LM16:
	mov_s r1,@.LC1	;9
	jl.d [r19]
	mov_s r0,r14	;0
	mov_s r1,r0	;0
.LBB173:
.LBB174:
.LM17:
	jl.d [r18]
	ld_s r0,[r15,92]		;11
.LBE174:
.LBE173:
.LM18:
	jl.d [r17]
	mov_s r1,r13	;0
.LM19:
	mov_s r2,r13	;0
	add r2,r2,512
	ldb r2,[r2,-28]
	breq_s r2, 0, @.L6
.LM20:
	mov_s r0,r13	;0
	add r0,r0,284
	jl @power_supply_unregister
.L6:
.LM21:
	mov_s r14,@power_supply_unregister	;9
	jl_s.d [r14]
	add_s r0,r13,4
.LM22:
	jl_s.d [r14]
	add3 r0,r13,18
.LM23:
	mov_s r0,r13	;0
	jl @kfree
.LM24:
	mov_s r12,40	;0
	b.d __ld_r13_to_r22_ret
	mov_s r0,0	;0
.LFE866:
	.size	wm831x_power_remove, .-wm831x_power_remove
	.align 4
	.type	wm831x_battey_apply_config, @function
wm831x_battey_apply_config:
.LFB856:
.LM25:
	add_s r12,r2,1
	mov_s lp_count,r12	;2
	cmp_s r2,0
	st.a r13,[sp,-4]       ;17
.LCFI2:
	mov_s r12,1	;0
	mov r13,lp_count		;6
	mov.ge r12,r13
	mov_s lp_count,r12	;2
	lp .L__GCC__LP12
	sr @.L12,[2]; LP_START
	0:
.LM26:
	mov_s r12,r3	;0
	mov_s r7,r1	;2
	mov_s r3,r5	;0
	mov r5,0		;3
	b_s @.L10
.L12:
.LM27:
	ld.ab r8,[r7,8]	;16
	breq.nd r12, r8, @.L11
	add r5,r5,1
.L10:
.LM28:
	nop
	
.L__GCC__LP12: ; loop end, start is @.L12
.L11:
.LM29:
	brne.d r5, r2, @.L13
	add3 r1,r1,r5
.LM30:
	ld_s r0,[r0,40]		;11
	mov_s r2,r3	;0
.LM31:
	ld_s r13,[sp]		;11
.LM32:
	mov_s r3,r12	;0
	mov r4,r6		;3
	mov_s r1,@.LC2	;9
.LM33:
	add_s sp,sp,4
.LM34:
	j @dev_err
.L13:
.LM35:
	ld r7,[r4]	;16
	ld_s r2,[r1,4]		;11
	or r2,r2,r7
	st r2,[r4]       ;17
.LBB175:
.LM36:
	ldw r2,[@.LANCHOR2+18]
	bbit0.nd r2,6,@.L15
	ld_s r1,[r0,40]		;11
.LBE175:
.LM37:
	ld_s r13,[sp]		;11
.LBB176:
.LM38:
	mov_s r4,r12	;2
	mov r5,r6		;3
	mov_s r0,@.LANCHOR2	;9
	mov_s r2,@.LC3	;9
.LBE176:
.LM39:
	add_s sp,sp,4
.LBB177:
.LM40:
	j @__dynamic_dev_dbg
.L15:
.LBE177:
.LM41:
	ld_s r13,[sp]		;11
	j_s.d [blink]
	add_s sp,sp,4
.LFE856:
	.size	wm831x_battey_apply_config, .-wm831x_battey_apply_config
	.align 4
	.type	wm831x_config_battery, @function
wm831x_config_battery:
.LFB857:
.LM42:
	push_s blink
.LCFI3:
.LCFI4:
	bl.d __st_r13_to_r16
	sub_s sp,sp,16
	mov_s r13,r0	;0
.LM43:
	ld_s r0,[r0,40]		;11
.LM44:
	sub_s sp,sp,8
.LCFI5:
.LM45:
	ld r2,[r0,176]	;16
.LM46:
	breq_s r2, 0, @.L19
	ld_s r14,[r2,96]		;11
	brne_s r14, 0, @.L20
.L19:
.LM47:
	mov_s r1,@.LC4	;9
	jl @dev_warn
.LM48:
	b_s @.L28
.L20:
.LM49:
	mov_s r2,0	;0
.LM50:
	st_s r2,[sp]		;12
.LM51:
	st_s r2,[sp,4]		;12
.LM52:
	ld_s r2,[r14]		;11
	brne_s r2, 0, @.L22
.LM53:
	mov_s r1,@.LC5	;9
	jl @_dev_info
.LM54:
	b_s @.L28
.L22:
.LM55:
	st 32768,[sp,4]      ;19
.LM56:
	ld_s r2,[r14,8]		;11
	breq_s r2, 0, @.L23
.LM57:
	st 16384,[sp]      ;19
.L23:
.LM58:
	ld_s r2,[r14,4]		;11
	breq_s r2, 0, @.L24
.LM59:
	st 32800,[sp,4]      ;19
.L24:
.LM60:
	ld_s r3,[r14,12]		;11
	mov_s r15,@wm831x_battey_apply_config	;9
	mov_s r1,@.LANCHOR0+84	;9
	mov_s r2,4	;0
	mov r4,sp		;3
	mov r5,@.LC6		;10
	mov r6,@.LC7		;10
	jl_s.d [r15]
	mov_s r0,r13	;0
.LM61:
	ld_s r3,[r14,16]		;11
	mov_s r0,r13	;0
	mov_s r1,@.LANCHOR0+116	;9
	mov_s r2,4	;0
	mov r5,@.LC8		;10
	mov r6,@.LC9		;10
	jl_s.d [r15]
	mov r4,sp		;3
.LM62:
	ld_s r3,[r14,24]		;11
	mov_s r0,r13	;0
	mov_s r1,@.LANCHOR0+148	;9
	mov_s r2,16	;0
	mov r5,@.LC10		;10
	mov r6,@.LC7		;10
	jl_s.d [r15]
	mov r4,sp		;3
.LM63:
	ld_s r3,[r14,20]		;11
	mov_s r0,r13	;0
	mov_s r1,@.LANCHOR0+276	;9
	mov_s r2,8	;0
	mov r5,@.LC11		;10
	mov r6,@.LC7		;10
	jl_s.d [r15]
	add r4,sp,4
.LM64:
	ld_s r3,[r14,28]		;11
	mov_s r2,16	;0
	mov_s r0,r13	;0
	mov_s r1,@.LANCHOR0+340	;9
	mov r5,@.LC12		;10
	mov r6,@.LC13		;10
	jl_s.d [r15]
	mov r4,sp		;3
.LM65:
	mov_s r0,r13	;0
	jl @wm831x_reg_unlock
.LM66:
	mov.f r2,r0
	beq_s @.L25
.LM67:
	ld_s r0,[r13,40]		;11
	mov_s r1,@.LC14	;9
	jl @dev_err
.LM68:
	b_s @.L28
.L25:
.LM69:
	ldw r3,[sp,6]
	mov_s r2,39968	;9
	mov_s r0,r13	;0
	mov_s r1,16456	;9
	jl @wm831x_set_bits
.LM70:
	mov.f r2,r0
	beq_s @.L26
.LM71:
	ld_s r0,[r13,40]		;11
	mov_s r1,@.LC15	;9
	jl @dev_err
.L26:
.LM72:
	ldw r3,[sp,2]
	mov_s r2,20479	;9
	mov_s r0,r13	;0
	mov_s r1,16457	;9
	jl @wm831x_set_bits
.LM73:
	mov.f r2,r0
	beq_s @.L27
.LM74:
	ld_s r0,[r13,40]		;11
	mov_s r1,@.LC16	;9
	jl @dev_err
.L27:
.LM75:
	mov_s r0,r13	;0
	jl @wm831x_reg_lock
.L28:
.LM76:
	add_s sp,sp,8
	mov_s r12,16	;0
	b __ld_r13_to_r16_ret
.LFE857:
	.size	wm831x_config_battery, .-wm831x_config_battery
	.align 4
	.type	wm831x_power_probe, @function
wm831x_power_probe:
.LFB865:
.LM77:
	push_s blink
.LCFI6:
.LCFI7:
	bl.d __st_r13_to_r24
	sub_s sp,sp,48
	mov_s r15,r0	;0
.LM78:
	ld_s r0,[r0,12]		;11
.LM79:
	sub_s sp,sp,8
.LCFI8:
.LM80:
	jl @dev_get_drvdata
.LM81:
	ld_s r2,[r0,40]		;11
.LM82:
	mov_s r14,r0	;0
.LBB178:
.LBB179:
.LBB180:
.LBB181:
.LBB182:
.LM83:
	ld r0,[@kmalloc_caches+36]	;16
	mov_s r1,32976	;9
.LBE182:
.LBE181:
.LBE180:
.LBE179:
.LBE178:
.LM84:
	ld r16,[r2,176]	;16
.LBB187:
.LBB186:
.LBB185:
.LBB184:
.LBB183:
.LM85:
	jl @kmem_cache_alloc
.LBE183:
.LBE184:
.LBE185:
.LBE186:
.LBE187:
.LM86:
	mov.f r13,r0
	bne_s @.L30
	mov r2,-12		;4
	st_s r2,[sp,4]		;12
	b @.L31
.L30:
.LBB188:
.LBB189:
.LM87:
	add r17,r15,12
.LBE189:
.LBE188:
.LM88:
	st_s r14,[r13]		;12
.LBB191:
.LBB190:
.LM89:
	mov_s r0,r17	;0
	mov_s r1,r13	;0
	jl @dev_set_drvdata
.LBE190:
.LBE191:
.LM90:
	breq.d r16, 0, @.L32
	add r19,r13,4
	ld r3,[r16]	;16
	breq_s r3, 0, @.L32
.LM91:
	add3 r0,r13,53
	mov r18,@snprintf		;10
	mov_s r2,@.LC17	;9
	jl.d [r18]
	mov_s r1,20	;0
.LM92:
	ld r3,[r16]	;16
	add3 r0,r13,58
	mov_s r2,@.LC18	;9
	jl.d [r18]
	mov_s r1,20	;0
.LM93:
	ld r3,[r16]	;16
	mov_s r0,r13	;0
	mov_s r1,20	;0
	mov_s r2,@.LC19	;9
	jl.d [r18]
	add r0,r0,444
.LM94:
	b_s @.L33
.L32:
.LM95:
	add3 r0,r13,53
	mov_s r2,@.LC20	;9
	mov r16,@snprintf		;10
	jl.d [r16]
	mov_s r1,20	;0
.LM96:
	add3 r0,r13,58
	mov_s r2,@.LC21	;9
	jl.d [r16]
	mov_s r1,20	;0
.LM97:
	mov_s r0,r13	;0
	add r0,r0,444
	mov_s r2,@.LC22	;9
	jl.d [r16]
	mov_s r1,20	;0
.L33:
.LM98:
	mov_s r0,r14	;0
	jl @wm831x_config_battery
.LM99:
	add3 r2,r13,53
.LM100:
	mov r18,2		;3
.LM101:
	st_s r2,[r13,4]		;12
.LM102:
	mov_s r2,3	;0
	st_s r2,[r13,8]		;12
.LM103:
	st @.LANCHOR0+468,[r13,12]      ;19
.LM104:
	st r18,[r13,16]       ;17
.LM105:
	st @wm831x_wall_get_prop,[r13,40]      ;19
.LM106:
	mov_s r0,r17	;0
	mov r16,@power_supply_register		;10
	jl.d [r16]
	mov_s r1,r19	;0
.LM107:
	mov.f r0,r0
	st_s r0,[sp,4]		;12
	bne @.L34
.LM108:
	mov_s r2,r13	;0
	add r2,r2,444
.LM109:
	add3 r20,r13,18
.LM110:
	st r2,[r13,144]       ;17
.LM111:
	mov_s r2,4	;0
	st r2,[r13,148]       ;17
.LM112:
	st r18,[r13,156]       ;17
.LM113:
	st @.LANCHOR0+476,[r13,152]      ;19
.LM114:
	st @wm831x_usb_get_prop,[r13,180]      ;19
.LM115:
	mov_s r0,r17	;0
	jl.d [r16]
	mov_s r1,r20	;0
.LM116:
	mov.f r0,r0
	st_s r0,[sp,4]		;12
	bne @.L35
.LM117:
	mov_s r0,r14	;0
	mov_s r1,16456	;9
	jl @wm831x_reg_read
	st_s r0,[sp,4]		;12
.LM118:
	cmp_s r0,0
	blt @.L35
.LM119:
	mov_s r2,r0	;0
	lsr_s r2,r2,15
	mov_s r3,r13	;0
	bmsk_s r2,r2,0
	add r3,r3,512
.LM120:
	mov_s r21,r13	;2
.LM121:
	stb r2,[r3,-28]
.LM122:
	add r21,r21,284
.LM123:
	breq_s r2, 0, @.L36
.LBB192:
.LM124:
	add3 r2,r13,58
.LM125:
	st.as @.LANCHOR0+484,[r13,73]      ;19
.LM126:
	st.as r2,[r13,71]       ;17
.LM127:
	mov_s r2,5	;0
	st.as r2,[r13,74]       ;17
.LM128:
	mov_s r2,1	;0
	st.as r2,[r13,85]       ;17
.LM129:
	st.as @wm831x_bat_get_prop,[r13,80]      ;19
.LM130:
	mov_s r0,r17	;0
	jl.d [r16]
	mov_s r1,r21	;0
.LM131:
	mov.f r0,r0
	st_s r0,[sp,4]		;12
	bne_s @.L37
.L36:
.LBE192:
.LM132:
	mov_s r1,@.LC1	;9
	mov r18,@platform_get_irq_byname		;10
	jl.d [r18]
	mov_s r0,r15	;0
	mov_s r1,r0	;0
.LBB193:
.LBB194:
.LM133:
	mov r24,@irq_create_mapping		;10
.LBE194:
.LBE193:
.LM134:
	mov r16,@request_threaded_irq		;10
.LBB196:
.LBB195:
.LM135:
	jl.d [r24]
	ld_s r0,[r14,92]		;11
.LBE195:
.LBE196:
.LM136:
	mov_s r1,0	;0
	mov_s r2,@wm831x_syslo_irq	;9
	mov_s r3,1	;0
	mov r4,@.LC23		;10
	mov_s r5,r13	;2
	jl.d [r16]
	mov_s r22,r0	;2
.LM137:
	mov.f r0,r0
	st_s r0,[sp,4]		;12
	beq_s @.L38
.LM138:
	ld_s r3,[sp,4]		;11
	mov_s r0,r17	;0
	mov_s r2,r22	;0
	mov_s r1,@.LC24	;9
	jl @dev_err
.LM139:
	b_s @.L39
.L38:
.LM140:
	mov_s r1,@.LC0	;9
	jl.d [r18]
	mov_s r0,r15	;0
	mov_s r1,r0	;0
.LBB197:
.LBB198:
.LM141:
	jl.d [r24]
	ld_s r0,[r14,92]		;11
.LBE198:
.LBE197:
.LM142:
	mov_s r1,0	;0
	mov_s r2,@wm831x_pwr_src_irq	;9
	mov_s r3,1	;0
	mov r4,@.LC25		;10
	mov_s r5,r13	;2
	jl.d [r16]
	mov_s r22,r0	;2
.LM143:
	mov.f r0,r0
	st_s r0,[sp,4]		;12
	bne_s @.L40
.LM144:
	mov_s r12,r18	;0
.LM145:
	mov r22,@.LANCHOR1		;10
	mov r16,0		;3
	b_s @.L41
.L40:
.LM146:
	ld_s r3,[sp,4]		;11
	mov_s r0,r17	;0
	mov_s r2,r22	;0
	mov_s r1,@.LC26	;9
	jl @dev_err
.LM147:
	b_s @.L42
.L41:
.LM148:
	ld.ab r18,[r22,4]	;16
	st_s r12,[sp]		;12
	mov_s r0,r15	;0
	jl_s.d [r12]
	mov_s r1,r18	;0
	mov_s r1,r0	;0
.LBB199:
.LBB200:
.LM149:
	jl.d [r24]
	ld_s r0,[r14,92]		;11
.LBE200:
.LBE199:
.LM150:
	mov_s r1,0	;0
	mov_s r2,@wm831x_bat_irq	;9
	mov_s r3,1	;0
	mov r4,r18		;3
	mov_s r5,r13	;2
.LBB202:
.LBB201:
.LM151:
	mov_s r23,r0	;2
.LBE201:
.LBE202:
.LM152:
	jl @request_threaded_irq
.LM153:
	mov.f r0,r0
	st_s r0,[sp,4]		;12
	ld_s r12,[sp]		;11
	beq_s @.L43
.LM154:
	ld r4,[sp,4]	;16
	mov_s r0,r17	;0
	mov_s r2,r18	;0
	mov_s r3,r23	;0
	mov_s r1,@.LC27	;9
	jl @dev_err
	add2 r17,@.LANCHOR1,r16
.LM155:
	mov r22,@platform_get_irq_byname		;10
.LM156:
	mov r18,@free_irq		;10
	b_s @.L44
.L43:
.LM157:
	add r16,r16,1
	brne r16, 8, @.L41
	b_s @.L31
.L44:
.LM158:
	ld.ab r1,[r17,-4]	;16
	mov_s r0,r15	;0
	jl.d [r22]
	sub r16,r16,1
.LM159:
	jl.d [r18]
	mov_s r1,r13	;0
.LM160:
	cmp r16,-1
	bne_s @.L44
.LM161:
	mov_s r1,@.LC0	;9
	mov_s r0,r15	;0
	jl @platform_get_irq_byname
	mov_s r1,r0	;0
.LBB203:
.LBB204:
.LM162:
	ld_s r0,[r14,92]		;11
	jl @irq_create_mapping
.LBE204:
.LBE203:
.LM163:
	mov_s r1,r13	;0
	jl @free_irq
.L42:
.LM164:
	mov_s r1,@.LC1	;9
	mov_s r0,r15	;0
	jl @platform_get_irq_byname
	mov_s r1,r0	;0
.LBB205:
.LBB206:
.LM165:
	ld_s r0,[r14,92]		;11
	jl @irq_create_mapping
.LBE206:
.LBE205:
.LM166:
	mov_s r1,r13	;0
	jl @free_irq
.L39:
.LM167:
	mov_s r2,r13	;0
	add r2,r2,512
	ldb r2,[r2,-28]
	breq_s r2, 0, @.L37
.LM168:
	mov_s r0,r21	;0
	jl @power_supply_unregister
.L37:
.LM169:
	mov_s r0,r20	;0
	jl @power_supply_unregister
.L35:
.LM170:
	mov_s r0,r19	;0
	jl @power_supply_unregister
.L34:
.LM171:
	mov_s r0,r13	;0
	jl @kfree
.L31:
.LM172:
	ld_s r0,[sp,4]		;11
	mov_s r12,48	;0
	add_s sp,sp,8
	b __ld_r13_to_r24_ret
.LFE865:
	.size	wm831x_power_probe, .-wm831x_power_probe
	.align 4
	.type	wm831x_bat_irq, @function
wm831x_bat_irq:
.LFB862:
.LM173:
.LBB207:
.LM174:
	ldw r2,[@.LANCHOR2+42]
.LBE207:
.LM175:
	push_s blink
.LCFI9:
	st.a r13,[sp,-4]       ;17
.LCFI10:
.LM176:
	ld_s r3,[r1]		;11
.LBB208:
.LM177:
	bbit0.d r2,6,@.L49
	mov_s r13,r1	;0
	ld_s r1,[r3,40]		;11
	mov_s r2,@.LC28	;9
	mov_s r3,r0	;0
	mov_s r0,@.LANCHOR2+24	;9
	jl @__dynamic_dev_dbg
.L49:
.LBE208:
.LM178:
	mov_s r2,r13	;0
	add r2,r2,512
	ldb r2,[r2,-28]
	breq_s r2, 0, @.L50
.LM179:
	mov_s r0,r13	;0
	add r0,r0,284
	jl @power_supply_changed
.L50:
.LM180:
	mov_s r0,1	;0
	ld blink,[sp,4]	;16
	ld_s r13,[sp]		;11
	j_s.d [blink]
	add_s sp,sp,8
.LFE862:
	.size	wm831x_bat_irq, .-wm831x_bat_irq
	.align 4
	.type	wm831x_pwr_src_irq, @function
wm831x_pwr_src_irq:
.LFB864:
.LM181:
	push_s blink
.LCFI11:
.LBB209:
.LM182:
	ldw r2,[@.LANCHOR2+66]
.LBE209:
.LM183:
	st.a r13,[sp,-8]       ;17
.LCFI12:
	mov_s r13,r1	;0
	st_s r14,[sp,4]		;12
.LCFI13:
.LBB210:
.LM184:
	bbit0.d r2,6,@.L53
	ld_s r3,[r1]		;11
	ld_s r1,[r3,40]		;11
	mov_s r0,@.LANCHOR2+48	;9
	mov_s r2,@.LC29	;9
	jl @__dynamic_dev_dbg
.L53:
.LBE210:
.LM185:
	mov_s r2,r13	;0
	add r2,r2,512
	ldb r2,[r2,-28]
	breq_s r2, 0, @.L54
.LM186:
	mov_s r0,r13	;0
	add r0,r0,284
	jl @power_supply_changed
.L54:
.LM187:
	mov_s r14,@power_supply_changed	;9
	jl_s.d [r14]
	add3 r0,r13,18
.LM188:
	jl_s.d [r14]
	add_s r0,r13,4
.LM189:
	mov_s r12,8	;0
	b.d __ld_r13_to_r14_ret
	mov_s r0,1	;0
.LFE864:
	.size	wm831x_pwr_src_irq, .-wm831x_pwr_src_irq
	.align 4
	.type	wm831x_syslo_irq, @function
wm831x_syslo_irq:
.LFB863:
.LM190:
	push_s blink
.LCFI14:
.LM191:
	ld_s r2,[r1]		;11
	mov_s r1,@.LC30	;9
	ld_s r0,[r2,40]		;11
	jl @dev_crit
.LM192:
	pop_s blink
	j_s.d [blink]
	mov_s r0,1	;0
.LFE863:
	.size	wm831x_syslo_irq, .-wm831x_syslo_irq
	.align 4
	.type	wm831x_bat_get_prop, @function
wm831x_bat_get_prop:
.LFB861:
.LM193:
	push_s blink
.LCFI15:
.LCFI16:
	bl.d __st_r13_to_r16
	sub_s sp,sp,16
.LM194:
	ld_s r3,[r0,60]		;11
.LM195:
	mov_s r15,r1	;0
	mov_s r13,r2	;0
.LM196:
	ld_s r0,[r3]		;11
	jl @dev_get_drvdata
.LM197:
	brhi.d r15, 12, @.L59
	ld_s r14,[r0]		;11
	add_s r15,r15,pcl
	ldb_s r2,[r15,10]
	add_s r2,r2,pcl
	j_s [r2]
.L65:
	.byte .L60-.L65 + 6
	.byte .L61-.L65 + 6
	.byte .L62-.L65 + 6
	.byte .L59-.L65 + 6
	.byte .L63-.L65 + 6
	.byte .L59-.L65 + 6
	.byte .L59-.L65 + 6
	.byte .L59-.L65 + 6
	.byte .L59-.L65 + 6
	.byte .L59-.L65 + 6
	.byte .L59-.L65 + 6
	.byte .L59-.L65 + 6
	.byte .L64-.L65 + 6
	.align 2
.L59:
	mov r0,-22		;4
	b_s @.L66
.L60:
.LBB211:
.LBB212:
.LM198:
	mov_s r1,16397	;9
	mov_s r15,@wm831x_reg_read	;9
	jl_s.d [r15]
	mov_s r0,r14	;0
.LM199:
	cmp_s r0,0
	blt @.L66
.LM200:
	and r16,r0,1024
	btst_s r0,10
	bne.d @.L86; bbit out of range
	mov_s r2,2	;0
.LM201:
	mov_s r1,16458	;9
	jl_s.d [r15]
	mov_s r0,r14	;0
.LM202:
	cmp_s r0,0
	blt @.L66
.LM203:
	and r0,r0,28672
	breq r0, 4096, @.L78
	breq r0, 8192, @.L78
	brne_s r0, 0, @.L83
.LM204:
	mov_s r2,3	;0
	st_s r2,[r13]		;12
	b_s @.L66
.L83:
.LM205:
	st r16,[r13]       ;17
	b_s @.L85
.L63:
.LBE212:
.LBE211:
.LBB213:
.LBB214:
.LM206:
	mov_s r0,r14	;0
	mov_s r1,16397	;9
	jl @wm831x_reg_read
.LM207:
	brlt.d r0, 0, @.L88
	mov_s r12,16	;0
.LM208:
	and r2,r0,1024
	bbit0 r0,10,@.L86
	b_s @.L78
.L64:
.LBE214:
.LBE213:
.LBB215:
.LBB216:
.LM209:
	mov_s r0,r14	;0
	mov_s r1,8	;0
	jl @wm831x_auxadc_read_uv
.LM210:
	brlt.nd r0, 0, @.L66
	st_s r0,[r13]		;12
	b_s @.L66
.L62:
.LBE216:
.LBE215:
.LBB217:
.LBB218:
.LM211:
	mov_s r0,r14	;0
	mov_s r1,16458	;9
	jl @wm831x_reg_read
.LM212:
	brlt.d r0, 0, @.L88
	mov_s r12,16	;0
.LM213:
	bbit1.d r0,11,@.L86
	mov_s r2,2	;0
.LM214:
	bbit0.nd r0,10,@.L73
	mov_s r2,6	;0
	b_s @.L86
.L73:
.LM215:
	bbit0.nd r0,15,@.L74
	mov_s r2,4	;0
	b_s @.L86
.L74:
.LM216:
	and r0,r0,28672
	breq r0, 16384, @.L79
	cmp_s r0,20480
.LM217:
	mov.eq r2,5
.LM218:
	beq_s @.L86
	brne r0, 12288, @.L78
	b_s @.L79
.L61:
.LBE218:
.LBE217:
.LBB219:
.LBB220:
.LM219:
	mov_s r0,r14	;0
	mov_s r1,16458	;9
	jl @wm831x_reg_read
.LM220:
	brlt.d r0, 0, @.L88
	mov_s r12,16	;0
.LM221:
	and r0,r0,28672
	breq r0, 8192, @.L80
	brgt r0, 8192, @.L81
	brne r0, 4096, @.L78
	b_s @.L79
.L81:
	breq r0, 12288, @.L79
	brne r0, 16384, @.L78
	b_s @.L80
.L79:
.LM222:
	mov_s r2,2	;0
	b_s @.L86
.L80:
.LM223:
	mov_s r2,3	;0
	b_s @.L86
.L78:
.LM224:
	mov_s r2,1	;0
.L86:
	st_s r2,[r13]		;12
.L85:
	mov_s r0,0	;0
.L66:
.LBE220:
.LBE219:
.LM225:
	mov_s r12,16	;0
.L88:
	b __ld_r13_to_r16_ret
.LFE861:
	.size	wm831x_bat_get_prop, .-wm831x_bat_get_prop
	.align 4
	.type	wm831x_usb_get_prop, @function
wm831x_usb_get_prop:
.LFB855:
.LM226:
	push_s blink
.LCFI17:
	st.a r13,[sp,-8]       ;17
.LCFI18:
	st_s r14,[sp,4]		;12
.LCFI19:
.LM227:
	ld_s r3,[r0,60]		;11
.LM228:
	mov_s r14,r1	;0
	mov_s r13,r2	;0
.LM229:
	ld_s r0,[r3]		;11
	jl @dev_get_drvdata
.LM230:
	breq.d r14, 4, @.L91
	ld_s r0,[r0]		;11
	cmp_s r14,12
	mov.ne r0,-22
	bne_s @.L93
	b_s @.L97
.L91:
.LBB221:
.LBB222:
.LM231:
	mov_s r1,16397	;9
	jl @wm831x_reg_read
.LM232:
	brlt.d r0, 0, @.L98
	mov_s r12,8	;0
.LM233:
	and r2,r0,256
	bbit0.nd r0,8,@.L94
	mov_s r2,1	;0
.L94:
.LM234:
	st_s r2,[r13]		;12
	mov_s r0,0	;0
	b_s @.L93
.L97:
.LBE222:
.LBE221:
.LBB223:
.LBB224:
.LM235:
	mov_s r1,7	;0
	jl @wm831x_auxadc_read_uv
.LM236:
	brlt.nd r0, 0, @.L93
	st_s r0,[r13]		;12
.L93:
.LBE224:
.LBE223:
.LM237:
	mov_s r12,8	;0
.L98:
	b __ld_r13_to_r14_ret
.LFE855:
	.size	wm831x_usb_get_prop, .-wm831x_usb_get_prop
	.align 4
	.type	wm831x_wall_get_prop, @function
wm831x_wall_get_prop:
.LFB854:
.LM238:
	push_s blink
.LCFI20:
	st.a r13,[sp,-8]       ;17
.LCFI21:
	st_s r14,[sp,4]		;12
.LCFI22:
.LM239:
	ld_s r3,[r0,60]		;11
.LM240:
	mov_s r14,r1	;0
	mov_s r13,r2	;0
.LM241:
	ld_s r0,[r3]		;11
	jl @dev_get_drvdata
.LM242:
	breq.d r14, 4, @.L101
	ld_s r0,[r0]		;11
	cmp_s r14,12
	mov.ne r0,-22
	bne_s @.L103
	b_s @.L107
.L101:
.LBB225:
.LBB226:
.LM243:
	mov_s r1,16397	;9
	jl @wm831x_reg_read
.LM244:
	brlt.d r0, 0, @.L108
	mov_s r12,8	;0
.LM245:
	and r2,r0,512
	bbit0.nd r0,9,@.L104
	mov_s r2,1	;0
.L104:
.LM246:
	st_s r2,[r13]		;12
	mov_s r0,0	;0
	b_s @.L103
.L107:
.LBE226:
.LBE225:
.LBB227:
.LBB228:
.LM247:
	mov_s r1,9	;0
	jl @wm831x_auxadc_read_uv
.LM248:
	brlt.nd r0, 0, @.L103
	st_s r0,[r13]		;12
.L103:
.LBE228:
.LBE227:
.LM249:
	mov_s r12,8	;0
.L108:
	b __ld_r13_to_r14_ret
.LFE854:
	.size	wm831x_wall_get_prop, .-wm831x_wall_get_prop
	.section	.init.text,"ax",@progbits
	.align 4
	.type	wm831x_power_driver_init, @function
wm831x_power_driver_init:
.LFB867:
.LSM2:
.LSM3:
	mov_s r0,@.LANCHOR0	;9
	mov_s r1,@__this_module	;9
	j @__platform_driver_register
.LFE867:
	.size	wm831x_power_driver_init, .-wm831x_power_driver_init
	.global	init_module
	.set	init_module,wm831x_power_driver_init
	.global	cleanup_module
	.set	cleanup_module,wm831x_power_driver_exit
	.section .rodata
	.align 4
	.set	.LANCHOR1,. + 0
	.type	wm831x_bat_irqs, @object
	.size	wm831x_bat_irqs, 32
wm831x_bat_irqs:
	.word	@.LC32
	.word	@.LC33
	.word	@.LC34
	.word	@.LC35
	.word	@.LC36
	.word	@.LC37
	.word	@.LC38
	.word	@.LC39
	.type	__func__.16138, @object
	.size	__func__.16138, 27
__func__.16138:
	.string	"wm831x_battey_apply_config"
	.zero	1
	.type	__func__.16308, @object
	.size	__func__.16308, 15
__func__.16308:
	.string	"wm831x_bat_irq"
	.zero	1
	.type	__func__.16336, @object
	.size	__func__.16336, 19
__func__.16336:
	.string	"wm831x_pwr_src_irq"
	.section	.modinfo,"a",@progbits
	.type	__UNIQUE_ID_alias3, @object
	.size	__UNIQUE_ID_alias3, 28
__UNIQUE_ID_alias3:
	.string	"alias=platform:wm831x-power"
	.type	__UNIQUE_ID_license2, @object
	.size	__UNIQUE_ID_license2, 12
__UNIQUE_ID_license2:
	.string	"license=GPL"
	.type	__UNIQUE_ID_author1, @object
	.size	__UNIQUE_ID_author1, 56
__UNIQUE_ID_author1:
	.string	"author=Mark Brown <broonie@opensource.wolfsonmicro.com>"
	.type	__UNIQUE_ID_description0, @object
	.size	__UNIQUE_ID_description0, 49
__UNIQUE_ID_description0:
	.string	"description=Power supply driver for WM831x PMICs"
	.section .data
	.align 4
	.set	.LANCHOR0,. + 0
	.type	wm831x_power_driver, @object
	.size	wm831x_power_driver, 84
wm831x_power_driver:
	.word	@wm831x_power_probe
	.word	@wm831x_power_remove
	.zero	12
	.word	@.LC31
	.zero	56
	.zero	4
	.type	trickle_ilims, @object
	.size	trickle_ilims, 32
trickle_ilims:
	.word	50
	.word	0
	.word	100
	.word	64
	.word	150
	.word	128
	.word	200
	.word	192
	.type	vsels, @object
	.size	vsels, 32
vsels:
	.word	4050
	.word	0
	.word	4100
	.word	16
	.word	4150
	.word	32
	.word	4200
	.word	48
	.type	fast_ilims, @object
	.size	fast_ilims, 128
fast_ilims:
	.word	0
	.word	0
	.word	50
	.word	1
	.word	100
	.word	2
	.word	150
	.word	3
	.word	200
	.word	4
	.word	250
	.word	5
	.word	300
	.word	6
	.word	350
	.word	7
	.word	400
	.word	8
	.word	450
	.word	9
	.word	500
	.word	10
	.word	600
	.word	11
	.word	700
	.word	12
	.word	800
	.word	13
	.word	900
	.word	14
	.word	1000
	.word	15
	.type	eoc_iterms, @object
	.size	eoc_iterms, 64
eoc_iterms:
	.word	20
	.word	0
	.word	30
	.word	1024
	.word	40
	.word	2048
	.word	50
	.word	3072
	.word	60
	.word	4096
	.word	70
	.word	5120
	.word	80
	.word	6144
	.word	90
	.word	7168
	.type	chg_times, @object
	.size	chg_times, 128
chg_times:
	.word	60
	.word	0
	.word	90
	.word	256
	.word	120
	.word	512
	.word	150
	.word	768
	.word	180
	.word	1024
	.word	210
	.word	1280
	.word	240
	.word	1536
	.word	270
	.word	1792
	.word	300
	.word	2048
	.word	330
	.word	2304
	.word	360
	.word	2560
	.word	390
	.word	2816
	.word	420
	.word	3072
	.word	450
	.word	3328
	.word	480
	.word	3584
	.word	510
	.word	3840
	.type	wm831x_wall_props, @object
	.size	wm831x_wall_props, 8
wm831x_wall_props:
	.word	4
	.word	12
	.type	wm831x_usb_props, @object
	.size	wm831x_usb_props, 8
wm831x_usb_props:
	.word	4
	.word	12
	.type	wm831x_bat_props, @object
	.size	wm831x_bat_props, 20
wm831x_bat_props:
	.word	0
	.word	4
	.word	12
	.word	2
	.word	1
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC0:
	.string	"PWR SRC"
.LC1:
	.string	"SYSLO"
	.zero	2
.LC2:
	.string	"Invalid %s %d%s\n"
	.zero	3
.LC3:
	.string	"Set %s of %d%s\n"
.LC4:
	.string	"No battery charger configuration\n"
	.zero	2
.LC5:
	.string	"Battery charger disabled\n"
	.zero	2
.LC6:
	.string	"trickle charge current limit"
	.zero	3
.LC7:
	.string	"mA"
	.zero	1
.LC8:
	.string	"target voltage"
	.zero	1
.LC9:
	.string	"mV"
	.zero	1
.LC10:
	.string	"fast charge current limit"
	.zero	2
.LC11:
	.string	"end of charge current threshold"
.LC12:
	.string	"charger timeout"
.LC13:
	.string	"min"
.LC14:
	.string	"Failed to unlock registers: %d\n"
.LC15:
	.string	"Failed to set charger control 1: %d\n"
	.zero	3
.LC16:
	.string	"Failed to set charger control 2: %d\n"
	.zero	3
.LC17:
	.string	"wm831x-wall.%d"
	.zero	1
.LC18:
	.string	"wm831x-battery.%d"
	.zero	2
.LC19:
	.string	"wm831x-usb.%d"
	.zero	2
.LC20:
	.string	"wm831x-wall"
.LC21:
	.string	"wm831x-battery"
	.zero	1
.LC22:
	.string	"wm831x-usb"
	.zero	1
.LC23:
	.string	"System power low"
	.zero	3
.LC24:
	.string	"Failed to request SYSLO IRQ %d: %d\n"
.LC25:
	.string	"Power source"
	.zero	3
.LC26:
	.string	"Failed to request PWR SRC IRQ %d: %d\n"
	.zero	2
.LC27:
	.string	"Failed to request %s IRQ %d: %d\n"
	.zero	3
.LC28:
	.string	"Battery status changed: %d\n"
.LC29:
	.string	"Power source changed\n"
	.zero	2
.LC30:
	.string	"SYSVDD under voltage\n"
	.zero	2
.LC31:
	.string	"wm831x-power"
	.zero	3
.LC32:
	.string	"BATT HOT"
	.zero	3
.LC33:
	.string	"BATT COLD"
	.zero	2
.LC34:
	.string	"BATT FAIL"
	.zero	2
.LC35:
	.string	"OV"
	.zero	1
.LC36:
	.string	"END"
.LC37:
	.string	"TO"
	.zero	1
.LC38:
	.string	"MODE"
	.zero	3
.LC39:
	.string	"START"
	.zero	2
.LC40:
	.string	"wm831x_power"
	.zero	3
.LC41:
	.string	"drivers/power/wm831x_power.c"
	.section	__verbose,"aw",@progbits
	.align 8
	.set	.LANCHOR2,. + 0
	.type	descriptor.16137, @object
	.size	descriptor.16137, 24
descriptor.16137:
	.word	@.LC40
	.word	@__func__.16138
	.word	@.LC41
	.word	@.LC3
	.byte	0
	.byte	53
	.byte	0
	.byte	64
	.zero	4
	.type	descriptor.16307, @object
	.size	descriptor.16307, 24
descriptor.16307:
	.word	@.LC40
	.word	@__func__.16308
	.word	@.LC41
	.word	@.LC28
	.byte	0
	.byte	112
	.byte	64
	.byte	64
	.zero	4
	.type	descriptor.16335, @object
	.size	descriptor.16335, 24
descriptor.16335:
	.word	@.LC40
	.word	@__func__.16336
	.word	@.LC41
	.word	@.LC29
	.byte	0
	.byte	120
	.byte	64
	.byte	64
	.zero	4
	.section	.debug_frame,"",@progbits
.Lframe0:
	.4byte	@.LECIE0-@.LSCIE0
.LSCIE0:
	.4byte	0xffffffff
	.byte	0x1
	.string	""
	.uleb128 0x1
	.sleb128 -4
	.byte	0x1f
	.byte	0xc
	.uleb128 0x1c
	.uleb128 0x0
	.align 4
.LECIE0:
.LSFDE0:
	.4byte	@.LEFDE0-@.LASFDE0
.LASFDE0:
	.4byte	@.Lframe0
	.4byte	@.LFB869
	.4byte	@.LFE869-@.LFB869
	.align 4
.LEFDE0:
.LSFDE2:
	.4byte	@.LEFDE2-@.LASFDE2
.LASFDE2:
	.4byte	@.Lframe0
	.4byte	@.LFB866
	.4byte	@.LFE866-@.LFB866
	.byte	0x4
	.4byte	@.LCFI0-@.LFB866
	.byte	0xe
	.uleb128 0x4
	.byte	0x4
	.4byte	@.LCFI1-@.LCFI0
	.byte	0xe
	.uleb128 0x2c
	.byte	0x11
	.uleb128 0x1f
	.sleb128 1
	.align 4
.LEFDE2:
.LSFDE4:
	.4byte	@.LEFDE4-@.LASFDE4
.LASFDE4:
	.4byte	@.Lframe0
	.4byte	@.LFB856
	.4byte	@.LFE856-@.LFB856
	.byte	0x4
	.4byte	@.LCFI2-@.LFB856
	.byte	0xe
	.uleb128 0x4
	.byte	0x11
	.uleb128 0xd
	.sleb128 1
	.align 4
.LEFDE4:
.LSFDE6:
	.4byte	@.LEFDE6-@.LASFDE6
.LASFDE6:
	.4byte	@.Lframe0
	.4byte	@.LFB857
	.4byte	@.LFE857-@.LFB857
	.byte	0x4
	.4byte	@.LCFI3-@.LFB857
	.byte	0xe
	.uleb128 0x4
	.byte	0x4
	.4byte	@.LCFI4-@.LCFI3
	.byte	0xe
	.uleb128 0x14
	.byte	0x4
	.4byte	@.LCFI5-@.LCFI4
	.byte	0xe
	.uleb128 0x1c
	.byte	0x11
	.uleb128 0x1f
	.sleb128 1
	.align 4
.LEFDE6:
.LSFDE8:
	.4byte	@.LEFDE8-@.LASFDE8
.LASFDE8:
	.4byte	@.Lframe0
	.4byte	@.LFB865
	.4byte	@.LFE865-@.LFB865
	.byte	0x4
	.4byte	@.LCFI6-@.LFB865
	.byte	0xe
	.uleb128 0x4
	.byte	0x4
	.4byte	@.LCFI7-@.LCFI6
	.byte	0xe
	.uleb128 0x34
	.byte	0x4
	.4byte	@.LCFI8-@.LCFI7
	.byte	0xe
	.uleb128 0x3c
	.byte	0x11
	.uleb128 0x1f
	.sleb128 1
	.align 4
.LEFDE8:
.LSFDE10:
	.4byte	@.LEFDE10-@.LASFDE10
.LASFDE10:
	.4byte	@.Lframe0
	.4byte	@.LFB862
	.4byte	@.LFE862-@.LFB862
	.byte	0x4
	.4byte	@.LCFI9-@.LFB862
	.byte	0xe
	.uleb128 0x4
	.byte	0x4
	.4byte	@.LCFI10-@.LCFI9
	.byte	0xe
	.uleb128 0x8
	.byte	0x11
	.uleb128 0xd
	.sleb128 2
	.byte	0x11
	.uleb128 0x1f
	.sleb128 1
	.align 4
.LEFDE10:
.LSFDE12:
	.4byte	@.LEFDE12-@.LASFDE12
.LASFDE12:
	.4byte	@.Lframe0
	.4byte	@.LFB864
	.4byte	@.LFE864-@.LFB864
	.byte	0x4
	.4byte	@.LCFI11-@.LFB864
	.byte	0xe
	.uleb128 0x4
	.byte	0x4
	.4byte	@.LCFI12-@.LCFI11
	.byte	0xe
	.uleb128 0xc
	.byte	0x11
	.uleb128 0xd
	.sleb128 3
	.byte	0x11
	.uleb128 0x1f
	.sleb128 1
	.byte	0x4
	.4byte	@.LCFI13-@.LCFI12
	.byte	0x11
	.uleb128 0xe
	.sleb128 2
	.align 4
.LEFDE12:
.LSFDE14:
	.4byte	@.LEFDE14-@.LASFDE14
.LASFDE14:
	.4byte	@.Lframe0
	.4byte	@.LFB863
	.4byte	@.LFE863-@.LFB863
	.byte	0x4
	.4byte	@.LCFI14-@.LFB863
	.byte	0xe
	.uleb128 0x4
	.byte	0x11
	.uleb128 0x1f
	.sleb128 1
	.align 4
.LEFDE14:
.LSFDE16:
	.4byte	@.LEFDE16-@.LASFDE16
.LASFDE16:
	.4byte	@.Lframe0
	.4byte	@.LFB861
	.4byte	@.LFE861-@.LFB861
	.byte	0x4
	.4byte	@.LCFI15-@.LFB861
	.byte	0xe
	.uleb128 0x4
	.byte	0x4
	.4byte	@.LCFI16-@.LCFI15
	.byte	0xe
	.uleb128 0x14
	.byte	0x11
	.uleb128 0x1f
	.sleb128 1
	.align 4
.LEFDE16:
.LSFDE18:
	.4byte	@.LEFDE18-@.LASFDE18
.LASFDE18:
	.4byte	@.Lframe0
	.4byte	@.LFB855
	.4byte	@.LFE855-@.LFB855
	.byte	0x4
	.4byte	@.LCFI17-@.LFB855
	.byte	0xe
	.uleb128 0x4
	.byte	0x4
	.4byte	@.LCFI18-@.LCFI17
	.byte	0xe
	.uleb128 0xc
	.byte	0x4
	.4byte	@.LCFI19-@.LCFI18
	.byte	0x11
	.uleb128 0xe
	.sleb128 2
	.byte	0x11
	.uleb128 0xd
	.sleb128 3
	.byte	0x11
	.uleb128 0x1f
	.sleb128 1
	.align 4
.LEFDE18:
.LSFDE20:
	.4byte	@.LEFDE20-@.LASFDE20
.LASFDE20:
	.4byte	@.Lframe0
	.4byte	@.LFB854
	.4byte	@.LFE854-@.LFB854
	.byte	0x4
	.4byte	@.LCFI20-@.LFB854
	.byte	0xe
	.uleb128 0x4
	.byte	0x4
	.4byte	@.LCFI21-@.LCFI20
	.byte	0xe
	.uleb128 0xc
	.byte	0x4
	.4byte	@.LCFI22-@.LCFI21
	.byte	0x11
	.uleb128 0xe
	.sleb128 2
	.byte	0x11
	.uleb128 0xd
	.sleb128 3
	.byte	0x11
	.uleb128 0x1f
	.sleb128 1
	.align 4
.LEFDE20:
.LSFDE22:
	.4byte	@.LEFDE22-@.LASFDE22
.LASFDE22:
	.4byte	@.Lframe0
	.4byte	@.LFB867
	.4byte	@.LFE867-@.LFB867
	.align 4
.LEFDE22:
	.section .text
.Letext0:
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST1:
	.4byte	@.LFB866
	.4byte	@.LCFI0
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI0
	.4byte	@.LCFI1
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	@.LCFI1
	.4byte	@.LFE866
	.2byte	0x2
	.byte	0x8c
	.sleb128 44
	.4byte	0x0
	.4byte	0x0
.LLST2:
	.4byte	@.LFB856
	.4byte	@.LCFI2
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI2
	.4byte	@.LFE856
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	0x0
	.4byte	0x0
.LLST3:
	.4byte	@.LFB857
	.4byte	@.LCFI3
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI3
	.4byte	@.LCFI4
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	@.LCFI4
	.4byte	@.LCFI5
	.2byte	0x2
	.byte	0x8c
	.sleb128 20
	.4byte	@.LCFI5
	.4byte	@.LFE857
	.2byte	0x2
	.byte	0x8c
	.sleb128 28
	.4byte	0x0
	.4byte	0x0
.LLST4:
	.4byte	@.LFB865
	.4byte	@.LCFI6
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI6
	.4byte	@.LCFI7
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	@.LCFI7
	.4byte	@.LCFI8
	.2byte	0x2
	.byte	0x8c
	.sleb128 52
	.4byte	@.LCFI8
	.4byte	@.LFE865
	.2byte	0x2
	.byte	0x8c
	.sleb128 60
	.4byte	0x0
	.4byte	0x0
.LLST5:
	.4byte	@.LFB862
	.4byte	@.LCFI9
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI9
	.4byte	@.LCFI10
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	@.LCFI10
	.4byte	@.LFE862
	.2byte	0x2
	.byte	0x8c
	.sleb128 8
	.4byte	0x0
	.4byte	0x0
.LLST6:
	.4byte	@.LFB864
	.4byte	@.LCFI11
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI11
	.4byte	@.LCFI12
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	@.LCFI12
	.4byte	@.LFE864
	.2byte	0x2
	.byte	0x8c
	.sleb128 12
	.4byte	0x0
	.4byte	0x0
.LLST7:
	.4byte	@.LFB863
	.4byte	@.LCFI14
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI14
	.4byte	@.LFE863
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	0x0
	.4byte	0x0
.LLST8:
	.4byte	@.LFB861
	.4byte	@.LCFI15
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI15
	.4byte	@.LCFI16
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	@.LCFI16
	.4byte	@.LFE861
	.2byte	0x2
	.byte	0x8c
	.sleb128 20
	.4byte	0x0
	.4byte	0x0
.LLST9:
	.4byte	@.LFB855
	.4byte	@.LCFI17
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI17
	.4byte	@.LCFI18
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	@.LCFI18
	.4byte	@.LFE855
	.2byte	0x2
	.byte	0x8c
	.sleb128 12
	.4byte	0x0
	.4byte	0x0
.LLST10:
	.4byte	@.LFB854
	.4byte	@.LCFI20
	.2byte	0x1
	.byte	0x6c
	.4byte	@.LCFI20
	.4byte	@.LCFI21
	.2byte	0x2
	.byte	0x8c
	.sleb128 4
	.4byte	@.LCFI21
	.4byte	@.LFE854
	.2byte	0x2
	.byte	0x8c
	.sleb128 12
	.4byte	0x0
	.4byte	0x0
	.section	.debug_info
	.4byte	0x177e
	.2byte	0x2
	.4byte	@.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	@.LASF342
	.byte	0x1
	.4byte	@.LASF343
	.4byte	@.LASF344
	.4byte	0x0
	.4byte	0x0
	.4byte	@.Ldebug_ranges0+0x110
	.4byte	@.Ldebug_line0
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.4byte	@.LASF0
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	@.LASF1
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.4byte	@.LASF2
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.4byte	@.LASF3
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	@.LASF4
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.4byte	@.LASF5
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.4byte	@.LASF6
	.uleb128 0x4
	.string	"u32"
	.byte	0x20
	.byte	0x16
	.4byte	0x4c
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.4byte	@.LASF7
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	@.LASF8
	.uleb128 0x5
	.4byte	@.LASF9
	.byte	0x5
	.byte	0x43
	.4byte	0x4c
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	@.LASF10
	.uleb128 0x5
	.4byte	@.LASF11
	.byte	0x6
	.byte	0x1d
	.4byte	0x97
	.uleb128 0x2
	.byte	0x1
	.byte	0x2
	.4byte	@.LASF12
	.uleb128 0x5
	.4byte	@.LASF13
	.byte	0x6
	.byte	0x36
	.4byte	0x7a
	.uleb128 0x5
	.4byte	@.LASF14
	.byte	0x6
	.byte	0x9d
	.4byte	0x4c
	.uleb128 0x6
	.4byte	@.LASF15
	.byte	0x1
	.uleb128 0x6
	.4byte	@.LASF16
	.byte	0x1
	.uleb128 0x7
	.byte	0x4
	.uleb128 0x8
	.4byte	@.LASF32
	.byte	0x4
	.byte	0x7
	.2byte	0x17f
	.4byte	0xfa
	.uleb128 0x9
	.4byte	@.LASF17
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF18
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF19
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF20
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF21
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF22
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF23
	.sleb128 4
	.byte	0x0
	.uleb128 0xa
	.byte	0x4
	.byte	0x8
	.byte	0x26
	.4byte	0x133
	.uleb128 0x9
	.4byte	@.LASF24
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF25
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF26
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF27
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF28
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF29
	.sleb128 4
	.uleb128 0x9
	.4byte	@.LASF30
	.sleb128 5
	.uleb128 0x9
	.4byte	@.LASF31
	.sleb128 6
	.byte	0x0
	.uleb128 0xb
	.4byte	@.LASF33
	.byte	0x4
	.byte	0x8
	.byte	0x69
	.4byte	0x1fa
	.uleb128 0x9
	.4byte	@.LASF34
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF35
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF36
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF37
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF38
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF39
	.sleb128 4
	.uleb128 0x9
	.4byte	@.LASF40
	.sleb128 5
	.uleb128 0x9
	.4byte	@.LASF41
	.sleb128 6
	.uleb128 0x9
	.4byte	@.LASF42
	.sleb128 7
	.uleb128 0x9
	.4byte	@.LASF43
	.sleb128 8
	.uleb128 0x9
	.4byte	@.LASF44
	.sleb128 9
	.uleb128 0x9
	.4byte	@.LASF45
	.sleb128 10
	.uleb128 0x9
	.4byte	@.LASF46
	.sleb128 11
	.uleb128 0x9
	.4byte	@.LASF47
	.sleb128 12
	.uleb128 0x9
	.4byte	@.LASF48
	.sleb128 13
	.uleb128 0x9
	.4byte	@.LASF49
	.sleb128 14
	.uleb128 0x9
	.4byte	@.LASF50
	.sleb128 15
	.uleb128 0x9
	.4byte	@.LASF51
	.sleb128 16
	.uleb128 0x9
	.4byte	@.LASF52
	.sleb128 17
	.uleb128 0x9
	.4byte	@.LASF53
	.sleb128 18
	.uleb128 0x9
	.4byte	@.LASF54
	.sleb128 19
	.uleb128 0x9
	.4byte	@.LASF55
	.sleb128 20
	.uleb128 0x9
	.4byte	@.LASF56
	.sleb128 21
	.uleb128 0x9
	.4byte	@.LASF57
	.sleb128 22
	.uleb128 0x9
	.4byte	@.LASF58
	.sleb128 23
	.uleb128 0x9
	.4byte	@.LASF59
	.sleb128 24
	.uleb128 0x9
	.4byte	@.LASF60
	.sleb128 25
	.uleb128 0x9
	.4byte	@.LASF61
	.sleb128 26
	.uleb128 0x9
	.4byte	@.LASF62
	.sleb128 27
	.uleb128 0x9
	.4byte	@.LASF63
	.sleb128 28
	.uleb128 0x9
	.4byte	@.LASF64
	.sleb128 29
	.byte	0x0
	.uleb128 0xb
	.4byte	@.LASF65
	.byte	0x4
	.byte	0x8
	.byte	0xa2
	.4byte	0x22b
	.uleb128 0x9
	.4byte	@.LASF66
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF67
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF68
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF69
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF70
	.sleb128 4
	.uleb128 0x9
	.4byte	@.LASF71
	.sleb128 5
	.byte	0x0
	.uleb128 0xb
	.4byte	@.LASF72
	.byte	0x4
	.byte	0x8
	.byte	0xe4
	.4byte	0x250
	.uleb128 0x9
	.4byte	@.LASF73
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF74
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF75
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF76
	.sleb128 3
	.byte	0x0
	.uleb128 0x6
	.4byte	@.LASF77
	.byte	0x1
	.uleb128 0xb
	.4byte	@.LASF78
	.byte	0x4
	.byte	0x9
	.byte	0x67
	.4byte	0x27b
	.uleb128 0x9
	.4byte	@.LASF79
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF80
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF81
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF82
	.sleb128 3
	.byte	0x0
	.uleb128 0xc
	.byte	0x4
	.byte	0x7
	.uleb128 0x6
	.4byte	@.LASF83
	.byte	0x1
	.uleb128 0x6
	.4byte	@.LASF84
	.byte	0x1
	.uleb128 0x6
	.4byte	@.LASF85
	.byte	0x1
	.uleb128 0x6
	.4byte	@.LASF86
	.byte	0x1
	.uleb128 0xa
	.byte	0x4
	.byte	0xa
	.byte	0x23
	.4byte	0x2bd
	.uleb128 0x9
	.4byte	@.LASF87
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF88
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF89
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF90
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF91
	.sleb128 4
	.byte	0x0
	.uleb128 0xa
	.byte	0x4
	.byte	0xa
	.byte	0x2b
	.4byte	0x2de
	.uleb128 0x9
	.4byte	@.LASF92
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF93
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF94
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF95
	.sleb128 3
	.byte	0x0
	.uleb128 0xa
	.byte	0x4
	.byte	0xa
	.byte	0x32
	.4byte	0x31d
	.uleb128 0x9
	.4byte	@.LASF96
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF97
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF98
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF99
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF100
	.sleb128 4
	.uleb128 0x9
	.4byte	@.LASF101
	.sleb128 5
	.uleb128 0x9
	.4byte	@.LASF102
	.sleb128 6
	.uleb128 0x9
	.4byte	@.LASF103
	.sleb128 7
	.uleb128 0x9
	.4byte	@.LASF104
	.sleb128 8
	.byte	0x0
	.uleb128 0xb
	.4byte	@.LASF105
	.byte	0x4
	.byte	0xa
	.byte	0x57
	.4byte	0x486
	.uleb128 0x9
	.4byte	@.LASF106
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF107
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF108
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF109
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF110
	.sleb128 4
	.uleb128 0x9
	.4byte	@.LASF111
	.sleb128 5
	.uleb128 0x9
	.4byte	@.LASF112
	.sleb128 6
	.uleb128 0x9
	.4byte	@.LASF113
	.sleb128 7
	.uleb128 0x9
	.4byte	@.LASF114
	.sleb128 8
	.uleb128 0x9
	.4byte	@.LASF115
	.sleb128 9
	.uleb128 0x9
	.4byte	@.LASF116
	.sleb128 10
	.uleb128 0x9
	.4byte	@.LASF117
	.sleb128 11
	.uleb128 0x9
	.4byte	@.LASF118
	.sleb128 12
	.uleb128 0x9
	.4byte	@.LASF119
	.sleb128 13
	.uleb128 0x9
	.4byte	@.LASF120
	.sleb128 14
	.uleb128 0x9
	.4byte	@.LASF121
	.sleb128 15
	.uleb128 0x9
	.4byte	@.LASF122
	.sleb128 16
	.uleb128 0x9
	.4byte	@.LASF123
	.sleb128 17
	.uleb128 0x9
	.4byte	@.LASF124
	.sleb128 18
	.uleb128 0x9
	.4byte	@.LASF125
	.sleb128 19
	.uleb128 0x9
	.4byte	@.LASF126
	.sleb128 20
	.uleb128 0x9
	.4byte	@.LASF127
	.sleb128 21
	.uleb128 0x9
	.4byte	@.LASF128
	.sleb128 22
	.uleb128 0x9
	.4byte	@.LASF129
	.sleb128 23
	.uleb128 0x9
	.4byte	@.LASF130
	.sleb128 24
	.uleb128 0x9
	.4byte	@.LASF131
	.sleb128 25
	.uleb128 0x9
	.4byte	@.LASF132
	.sleb128 26
	.uleb128 0x9
	.4byte	@.LASF133
	.sleb128 27
	.uleb128 0x9
	.4byte	@.LASF134
	.sleb128 28
	.uleb128 0x9
	.4byte	@.LASF135
	.sleb128 29
	.uleb128 0x9
	.4byte	@.LASF136
	.sleb128 30
	.uleb128 0x9
	.4byte	@.LASF137
	.sleb128 31
	.uleb128 0x9
	.4byte	@.LASF138
	.sleb128 32
	.uleb128 0x9
	.4byte	@.LASF139
	.sleb128 33
	.uleb128 0x9
	.4byte	@.LASF140
	.sleb128 34
	.uleb128 0x9
	.4byte	@.LASF141
	.sleb128 35
	.uleb128 0x9
	.4byte	@.LASF142
	.sleb128 36
	.uleb128 0x9
	.4byte	@.LASF143
	.sleb128 37
	.uleb128 0x9
	.4byte	@.LASF144
	.sleb128 38
	.uleb128 0x9
	.4byte	@.LASF145
	.sleb128 39
	.uleb128 0x9
	.4byte	@.LASF146
	.sleb128 40
	.uleb128 0x9
	.4byte	@.LASF147
	.sleb128 41
	.uleb128 0x9
	.4byte	@.LASF148
	.sleb128 42
	.uleb128 0x9
	.4byte	@.LASF149
	.sleb128 43
	.uleb128 0x9
	.4byte	@.LASF150
	.sleb128 44
	.uleb128 0x9
	.4byte	@.LASF151
	.sleb128 45
	.uleb128 0x9
	.4byte	@.LASF152
	.sleb128 46
	.uleb128 0x9
	.4byte	@.LASF153
	.sleb128 47
	.uleb128 0x9
	.4byte	@.LASF154
	.sleb128 48
	.uleb128 0x9
	.4byte	@.LASF155
	.sleb128 49
	.uleb128 0x9
	.4byte	@.LASF156
	.sleb128 50
	.uleb128 0x9
	.4byte	@.LASF157
	.sleb128 51
	.uleb128 0x9
	.4byte	@.LASF158
	.sleb128 52
	.uleb128 0x9
	.4byte	@.LASF159
	.sleb128 53
	.uleb128 0x9
	.4byte	@.LASF160
	.sleb128 54
	.uleb128 0x9
	.4byte	@.LASF161
	.sleb128 55
	.uleb128 0x9
	.4byte	@.LASF162
	.sleb128 56
	.uleb128 0x9
	.4byte	@.LASF163
	.sleb128 57
	.byte	0x0
	.uleb128 0xb
	.4byte	@.LASF164
	.byte	0x4
	.byte	0xa
	.byte	0x96
	.4byte	0x4c3
	.uleb128 0x9
	.4byte	@.LASF165
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF166
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF167
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF168
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF169
	.sleb128 4
	.uleb128 0x9
	.4byte	@.LASF170
	.sleb128 5
	.uleb128 0x9
	.4byte	@.LASF171
	.sleb128 6
	.uleb128 0x9
	.4byte	@.LASF172
	.sleb128 7
	.byte	0x0
	.uleb128 0xd
	.4byte	@.LASF345
	.byte	0x1
	.uleb128 0x6
	.4byte	@.LASF173
	.byte	0x1
	.uleb128 0xb
	.4byte	@.LASF174
	.byte	0x4
	.byte	0xb
	.byte	0xb
	.4byte	0x57e
	.uleb128 0x9
	.4byte	@.LASF175
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF176
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF177
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF178
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF179
	.sleb128 4
	.uleb128 0x9
	.4byte	@.LASF180
	.sleb128 5
	.uleb128 0x9
	.4byte	@.LASF181
	.sleb128 6
	.uleb128 0x9
	.4byte	@.LASF182
	.sleb128 7
	.uleb128 0x9
	.4byte	@.LASF183
	.sleb128 8
	.uleb128 0x9
	.4byte	@.LASF184
	.sleb128 9
	.uleb128 0x9
	.4byte	@.LASF185
	.sleb128 10
	.uleb128 0x9
	.4byte	@.LASF186
	.sleb128 11
	.uleb128 0x9
	.4byte	@.LASF187
	.sleb128 12
	.uleb128 0x9
	.4byte	@.LASF188
	.sleb128 13
	.uleb128 0x9
	.4byte	@.LASF189
	.sleb128 14
	.uleb128 0x9
	.4byte	@.LASF190
	.sleb128 15
	.uleb128 0x9
	.4byte	@.LASF191
	.sleb128 16
	.uleb128 0x9
	.4byte	@.LASF192
	.sleb128 17
	.uleb128 0x9
	.4byte	@.LASF193
	.sleb128 18
	.uleb128 0x9
	.4byte	@.LASF194
	.sleb128 19
	.uleb128 0x9
	.4byte	@.LASF195
	.sleb128 20
	.uleb128 0x9
	.4byte	@.LASF196
	.sleb128 21
	.uleb128 0x9
	.4byte	@.LASF197
	.sleb128 22
	.uleb128 0x9
	.4byte	@.LASF198
	.sleb128 23
	.uleb128 0x9
	.4byte	@.LASF199
	.sleb128 24
	.uleb128 0x9
	.4byte	@.LASF200
	.sleb128 25
	.uleb128 0x9
	.4byte	@.LASF201
	.sleb128 26
	.byte	0x0
	.uleb128 0x6
	.4byte	@.LASF202
	.byte	0x1
	.uleb128 0xb
	.4byte	@.LASF203
	.byte	0x4
	.byte	0xc
	.byte	0xa
	.4byte	0x5a3
	.uleb128 0x9
	.4byte	@.LASF204
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF205
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF206
	.sleb128 2
	.byte	0x0
	.uleb128 0x5
	.4byte	@.LASF207
	.byte	0xc
	.byte	0x10
	.4byte	0x584
	.uleb128 0xb
	.4byte	@.LASF208
	.byte	0x4
	.byte	0xd
	.byte	0x9c
	.4byte	0x5d9
	.uleb128 0x9
	.4byte	@.LASF209
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF210
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF211
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF212
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF213
	.sleb128 4
	.byte	0x0
	.uleb128 0xe
	.byte	0x4
	.byte	0xe
	.2byte	0x158
	.4byte	0x625
	.uleb128 0x9
	.4byte	@.LASF214
	.sleb128 0
	.uleb128 0x9
	.4byte	@.LASF215
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF216
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF217
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF218
	.sleb128 4
	.uleb128 0x9
	.4byte	@.LASF219
	.sleb128 5
	.uleb128 0x9
	.4byte	@.LASF220
	.sleb128 6
	.uleb128 0x9
	.4byte	@.LASF221
	.sleb128 7
	.uleb128 0x9
	.4byte	@.LASF222
	.sleb128 8
	.uleb128 0x9
	.4byte	@.LASF223
	.sleb128 9
	.uleb128 0x9
	.4byte	@.LASF224
	.sleb128 10
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x62b
	.uleb128 0x10
	.uleb128 0xb
	.4byte	@.LASF225
	.byte	0x4
	.byte	0xf
	.byte	0xc8
	.4byte	0x681
	.uleb128 0x9
	.4byte	@.LASF226
	.sleb128 15
	.uleb128 0x9
	.4byte	@.LASF227
	.sleb128 10
	.uleb128 0x9
	.4byte	@.LASF228
	.sleb128 9
	.uleb128 0x9
	.4byte	@.LASF229
	.sleb128 8
	.uleb128 0x9
	.4byte	@.LASF230
	.sleb128 7
	.uleb128 0x9
	.4byte	@.LASF231
	.sleb128 6
	.uleb128 0x9
	.4byte	@.LASF232
	.sleb128 5
	.uleb128 0x9
	.4byte	@.LASF233
	.sleb128 4
	.uleb128 0x9
	.4byte	@.LASF234
	.sleb128 3
	.uleb128 0x9
	.4byte	@.LASF235
	.sleb128 2
	.uleb128 0x9
	.4byte	@.LASF236
	.sleb128 1
	.uleb128 0x9
	.4byte	@.LASF237
	.sleb128 0
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x687
	.uleb128 0x6
	.4byte	@.LASF238
	.byte	0x1
	.uleb128 0x6
	.4byte	@.LASF239
	.byte	0x1
	.uleb128 0x6
	.4byte	@.LASF240
	.byte	0x1
	.uleb128 0x11
	.4byte	@.LASF247
	.2byte	0x1e8
	.byte	0x1
	.byte	0x16
	.4byte	0x71d
	.uleb128 0x12
	.4byte	@.LASF238
	.byte	0x1
	.byte	0x17
	.4byte	0x681
	.byte	0x2
	.byte	0x23
	.uleb128 0x0
	.uleb128 0x12
	.4byte	@.LASF241
	.byte	0x1
	.byte	0x18
	.4byte	0x4c9
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0x13
	.string	"usb"
	.byte	0x1
	.byte	0x19
	.4byte	0x4c9
	.byte	0x3
	.byte	0x23
	.uleb128 0x90
	.uleb128 0x12
	.4byte	@.LASF242
	.byte	0x1
	.byte	0x1a
	.4byte	0x4c9
	.byte	0x3
	.byte	0x23
	.uleb128 0x11c
	.uleb128 0x12
	.4byte	@.LASF243
	.byte	0x1
	.byte	0x1b
	.4byte	0x71d
	.byte	0x3
	.byte	0x23
	.uleb128 0x1a8
	.uleb128 0x12
	.4byte	@.LASF244
	.byte	0x1
	.byte	0x1c
	.4byte	0x71d
	.byte	0x3
	.byte	0x23
	.uleb128 0x1bc
	.uleb128 0x12
	.4byte	@.LASF245
	.byte	0x1
	.byte	0x1d
	.4byte	0x71d
	.byte	0x3
	.byte	0x23
	.uleb128 0x1d0
	.uleb128 0x12
	.4byte	@.LASF246
	.byte	0x1
	.byte	0x1e
	.4byte	0x8c
	.byte	0x3
	.byte	0x23
	.uleb128 0x1e4
	.byte	0x0
	.uleb128 0x14
	.4byte	0x85
	.4byte	0x72d
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x13
	.byte	0x0
	.uleb128 0x16
	.4byte	@.LASF248
	.byte	0x8
	.byte	0x1
	.byte	0x81
	.4byte	0x756
	.uleb128 0x13
	.string	"val"
	.byte	0x1
	.byte	0x82
	.4byte	0x45
	.byte	0x2
	.byte	0x23
	.uleb128 0x0
	.uleb128 0x12
	.4byte	@.LASF249
	.byte	0x1
	.byte	0x83
	.4byte	0x45
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.byte	0x0
	.uleb128 0x17
	.4byte	@.LASF250
	.byte	0x2
	.byte	0xc9
	.byte	0x1
	.4byte	0xc0
	.byte	0x3
	.4byte	0x773
	.uleb128 0x18
	.4byte	@.LASF252
	.byte	0x2
	.byte	0xc9
	.4byte	0x773
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x779
	.uleb128 0x19
	.4byte	@.LASF85
	.4byte	0x28a
	.uleb128 0x1a
	.4byte	@.LASF251
	.byte	0x3
	.2byte	0x1a7
	.byte	0x1
	.4byte	0x45
	.byte	0x3
	.4byte	0x7ad
	.uleb128 0x1b
	.4byte	@.LASF238
	.byte	0x3
	.2byte	0x1a7
	.4byte	0x681
	.uleb128 0x1c
	.string	"irq"
	.byte	0x3
	.2byte	0x1a7
	.4byte	0x45
	.byte	0x0
	.uleb128 0x1a
	.4byte	@.LASF253
	.byte	0x10
	.2byte	0x1a7
	.byte	0x1
	.4byte	0x45
	.byte	0x3
	.4byte	0x7d4
	.uleb128 0x1c
	.string	"x"
	.byte	0x10
	.2byte	0x1a7
	.4byte	0x45
	.uleb128 0x1d
	.string	"r"
	.byte	0x10
	.2byte	0x1a9
	.4byte	0x45
	.byte	0x0
	.uleb128 0x1e
	.string	"clz"
	.byte	0x10
	.2byte	0x198
	.byte	0x1
	.4byte	0x45
	.byte	0x3
	.4byte	0x7fd
	.uleb128 0x1c
	.string	"x"
	.byte	0x10
	.2byte	0x198
	.4byte	0x4c
	.uleb128 0x1d
	.string	"res"
	.byte	0x10
	.2byte	0x19a
	.4byte	0x4c
	.byte	0x0
	.uleb128 0x1e
	.string	"fls"
	.byte	0x10
	.2byte	0x1c9
	.byte	0x1
	.4byte	0x45
	.byte	0x3
	.4byte	0x81a
	.uleb128 0x1c
	.string	"x"
	.byte	0x10
	.2byte	0x1c9
	.4byte	0x73
	.byte	0x0
	.uleb128 0x1f
	.4byte	@.LASF269
	.byte	0x11
	.byte	0x40
	.byte	0x1
	.byte	0x3
	.4byte	0x854
	.uleb128 0x20
	.string	"ptr"
	.byte	0x11
	.byte	0x40
	.4byte	0x625
	.uleb128 0x18
	.4byte	@.LASF254
	.byte	0x11
	.byte	0x40
	.4byte	0x9e
	.uleb128 0x18
	.4byte	@.LASF255
	.byte	0x11
	.byte	0x40
	.4byte	0x45
	.uleb128 0x20
	.string	"gfp"
	.byte	0x11
	.byte	0x41
	.4byte	0xa9
	.byte	0x0
	.uleb128 0x1a
	.4byte	@.LASF256
	.byte	0x4
	.2byte	0x163
	.byte	0x1
	.4byte	0xc0
	.byte	0x3
	.4byte	0x897
	.uleb128 0x1b
	.4byte	@.LASF254
	.byte	0x4
	.2byte	0x163
	.4byte	0x9e
	.uleb128 0x1b
	.4byte	@.LASF257
	.byte	0x4
	.2byte	0x163
	.4byte	0xa9
	.uleb128 0x1b
	.4byte	@.LASF258
	.byte	0x4
	.2byte	0x163
	.4byte	0x4c
	.uleb128 0x1d
	.string	"ret"
	.byte	0x4
	.2byte	0x165
	.4byte	0xc0
	.byte	0x0
	.uleb128 0x17
	.4byte	@.LASF259
	.byte	0x12
	.byte	0x20
	.byte	0x1
	.4byte	0x45
	.byte	0x3
	.4byte	0x8b2
	.uleb128 0x20
	.string	"n"
	.byte	0x12
	.byte	0x20
	.4byte	0x61
	.byte	0x0
	.uleb128 0x17
	.4byte	@.LASF260
	.byte	0x13
	.byte	0xd
	.byte	0x1
	.4byte	0x45
	.byte	0x3
	.4byte	0x8da
	.uleb128 0x18
	.4byte	@.LASF254
	.byte	0x13
	.byte	0xd
	.4byte	0x73
	.uleb128 0x21
	.4byte	@.LASF258
	.byte	0x13
	.byte	0xf
	.4byte	0x45
	.byte	0x0
	.uleb128 0x1a
	.4byte	@.LASF261
	.byte	0x4
	.2byte	0x171
	.byte	0x1
	.4byte	0xc0
	.byte	0x3
	.4byte	0x911
	.uleb128 0x1b
	.4byte	@.LASF254
	.byte	0x4
	.2byte	0x171
	.4byte	0x9e
	.uleb128 0x1b
	.4byte	@.LASF257
	.byte	0x4
	.2byte	0x171
	.4byte	0xa9
	.uleb128 0x1b
	.4byte	@.LASF258
	.byte	0x4
	.2byte	0x171
	.4byte	0x4c
	.byte	0x0
	.uleb128 0x1a
	.4byte	@.LASF262
	.byte	0x4
	.2byte	0x177
	.byte	0x1
	.4byte	0xc0
	.byte	0x3
	.4byte	0x948
	.uleb128 0x1b
	.4byte	@.LASF254
	.byte	0x4
	.2byte	0x177
	.4byte	0x9e
	.uleb128 0x1b
	.4byte	@.LASF257
	.byte	0x4
	.2byte	0x177
	.4byte	0xa9
	.uleb128 0x22
	.4byte	@.LASF258
	.byte	0x4
	.2byte	0x179
	.4byte	0x4c
	.byte	0x0
	.uleb128 0x17
	.4byte	@.LASF263
	.byte	0x4
	.byte	0xfc
	.byte	0x1
	.4byte	0x45
	.byte	0x3
	.4byte	0x973
	.uleb128 0x18
	.4byte	@.LASF254
	.byte	0x4
	.byte	0xfc
	.4byte	0x9e
	.uleb128 0x23
	.4byte	@.LASF264
	.4byte	0x983
	.byte	0x1
	.4byte	@.LASF263
	.byte	0x0
	.uleb128 0x14
	.4byte	0x85
	.4byte	0x983
	.uleb128 0x15
	.4byte	0x27b
	.byte	0xd
	.byte	0x0
	.uleb128 0x24
	.4byte	0x973
	.uleb128 0x1a
	.4byte	@.LASF265
	.byte	0x4
	.2byte	0x14b
	.byte	0x1
	.4byte	0xc0
	.byte	0x3
	.4byte	0x9bd
	.uleb128 0x1c
	.string	"s"
	.byte	0x4
	.2byte	0x14b
	.4byte	0x9bd
	.uleb128 0x1b
	.4byte	@.LASF257
	.byte	0x4
	.2byte	0x14c
	.4byte	0xa9
	.uleb128 0x1b
	.4byte	@.LASF254
	.byte	0x4
	.2byte	0x14c
	.4byte	0x9e
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x57e
	.uleb128 0x1a
	.4byte	@.LASF266
	.byte	0x4
	.2byte	0x185
	.byte	0x1
	.4byte	0xc0
	.byte	0x3
	.4byte	0x9fc
	.uleb128 0x1b
	.4byte	@.LASF254
	.byte	0x4
	.2byte	0x185
	.4byte	0x9e
	.uleb128 0x1b
	.4byte	@.LASF257
	.byte	0x4
	.2byte	0x185
	.4byte	0xa9
	.uleb128 0x25
	.uleb128 0x22
	.4byte	@.LASF267
	.byte	0x4
	.2byte	0x18c
	.4byte	0x45
	.byte	0x0
	.byte	0x0
	.uleb128 0x1a
	.4byte	@.LASF268
	.byte	0x4
	.2byte	0x27c
	.byte	0x1
	.4byte	0xc0
	.byte	0x3
	.4byte	0xa27
	.uleb128 0x1b
	.4byte	@.LASF254
	.byte	0x4
	.2byte	0x27c
	.4byte	0x9e
	.uleb128 0x1b
	.4byte	@.LASF257
	.byte	0x4
	.2byte	0x27c
	.4byte	0xa9
	.byte	0x0
	.uleb128 0x1f
	.4byte	@.LASF270
	.byte	0x2
	.byte	0xce
	.byte	0x1
	.byte	0x3
	.4byte	0xa4b
	.uleb128 0x18
	.4byte	@.LASF252
	.byte	0x2
	.byte	0xce
	.4byte	0xa4b
	.uleb128 0x18
	.4byte	@.LASF271
	.byte	0x2
	.byte	0xcf
	.4byte	0xc0
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x28a
	.uleb128 0x1a
	.4byte	@.LASF272
	.byte	0x1
	.2byte	0x126
	.byte	0x1
	.4byte	0x45
	.byte	0x1
	.4byte	0xa88
	.uleb128 0x1b
	.4byte	@.LASF238
	.byte	0x1
	.2byte	0x126
	.4byte	0x681
	.uleb128 0x1b
	.4byte	@.LASF273
	.byte	0x1
	.2byte	0x126
	.4byte	0xa88
	.uleb128 0x1d
	.string	"ret"
	.byte	0x1
	.2byte	0x128
	.4byte	0x45
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x45
	.uleb128 0x17
	.4byte	@.LASF274
	.byte	0x1
	.byte	0x21
	.byte	0x1
	.4byte	0x45
	.byte	0x1
	.4byte	0xacc
	.uleb128 0x18
	.4byte	@.LASF238
	.byte	0x1
	.byte	0x21
	.4byte	0x681
	.uleb128 0x18
	.4byte	@.LASF275
	.byte	0x1
	.byte	0x21
	.4byte	0x45
	.uleb128 0x20
	.string	"val"
	.byte	0x1
	.byte	0x22
	.4byte	0xacc
	.uleb128 0x26
	.string	"ret"
	.byte	0x1
	.byte	0x24
	.4byte	0x45
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x4c3
	.uleb128 0x17
	.4byte	@.LASF276
	.byte	0x1
	.byte	0x32
	.byte	0x1
	.4byte	0x45
	.byte	0x1
	.4byte	0xb10
	.uleb128 0x18
	.4byte	@.LASF238
	.byte	0x1
	.byte	0x32
	.4byte	0x681
	.uleb128 0x20
	.string	"src"
	.byte	0x1
	.byte	0x33
	.4byte	0x62c
	.uleb128 0x20
	.string	"val"
	.byte	0x1
	.byte	0x34
	.4byte	0xacc
	.uleb128 0x26
	.string	"ret"
	.byte	0x1
	.byte	0x36
	.4byte	0x45
	.byte	0x0
	.uleb128 0x1a
	.4byte	@.LASF277
	.byte	0x1
	.2byte	0x161
	.byte	0x1
	.4byte	0x45
	.byte	0x1
	.4byte	0xb47
	.uleb128 0x1b
	.4byte	@.LASF238
	.byte	0x1
	.2byte	0x161
	.4byte	0x681
	.uleb128 0x1b
	.4byte	@.LASF278
	.byte	0x1
	.2byte	0x161
	.4byte	0xa88
	.uleb128 0x1d
	.string	"ret"
	.byte	0x1
	.2byte	0x163
	.4byte	0x45
	.byte	0x0
	.uleb128 0x1a
	.4byte	@.LASF279
	.byte	0x1
	.2byte	0x148
	.byte	0x1
	.4byte	0x45
	.byte	0x1
	.4byte	0xb7e
	.uleb128 0x1b
	.4byte	@.LASF238
	.byte	0x1
	.2byte	0x148
	.4byte	0x681
	.uleb128 0x1b
	.4byte	@.LASF280
	.byte	0x1
	.2byte	0x148
	.4byte	0xa88
	.uleb128 0x1d
	.string	"ret"
	.byte	0x1
	.2byte	0x14a
	.4byte	0x45
	.byte	0x0
	.uleb128 0x27
	.4byte	@.LASF346
	.byte	0x1
	.2byte	0x297
	.byte	0x1
	.4byte	@.LFB869
	.4byte	@.LFE869
	.byte	0x1
	.byte	0x6c
	.uleb128 0x28
	.4byte	@.LASF290
	.byte	0x1
	.2byte	0x274
	.byte	0x1
	.4byte	0x45
	.4byte	@.LFB866
	.4byte	@.LFE866
	.4byte	@.LLST1
	.4byte	0xc62
	.uleb128 0x29
	.4byte	@.LASF252
	.byte	0x1
	.2byte	0x274
	.4byte	0xa4b
	.byte	0x1
	.byte	0x5e
	.uleb128 0x2a
	.4byte	@.LASF247
	.byte	0x1
	.2byte	0x276
	.4byte	0xc62
	.byte	0x1
	.byte	0x5d
	.uleb128 0x2a
	.4byte	@.LASF238
	.byte	0x1
	.2byte	0x277
	.4byte	0x681
	.byte	0x1
	.byte	0x5f
	.uleb128 0x1d
	.string	"irq"
	.byte	0x1
	.2byte	0x278
	.4byte	0x45
	.uleb128 0x1d
	.string	"i"
	.byte	0x1
	.2byte	0x278
	.4byte	0x45
	.uleb128 0x2b
	.4byte	0x756
	.4byte	@.LBB165
	.4byte	@.Ldebug_ranges0+0x0
	.byte	0x1
	.2byte	0x276
	.4byte	0xc08
	.uleb128 0x2c
	.4byte	0x767
	.byte	0x0
	.uleb128 0x2d
	.4byte	0x782
	.4byte	@.LBB169
	.4byte	@.LBE169
	.byte	0x1
	.2byte	0x27b
	.4byte	0xc27
	.uleb128 0x2c
	.4byte	0x7a0
	.uleb128 0x2c
	.4byte	0x794
	.byte	0x0
	.uleb128 0x2d
	.4byte	0x782
	.4byte	@.LBB171
	.4byte	@.LBE171
	.byte	0x1
	.2byte	0x281
	.4byte	0xc46
	.uleb128 0x2c
	.4byte	0x7a0
	.uleb128 0x2c
	.4byte	0x794
	.byte	0x0
	.uleb128 0x2e
	.4byte	0x782
	.4byte	@.LBB173
	.4byte	@.LBE173
	.byte	0x1
	.2byte	0x284
	.uleb128 0x2c
	.4byte	0x7a0
	.uleb128 0x2c
	.4byte	0x794
	.byte	0x0
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x699
	.uleb128 0x2f
	.4byte	@.LASF285
	.byte	0x1
	.byte	0xc5
	.byte	0x1
	.4byte	@.LFB856
	.4byte	@.LFE856
	.4byte	@.LLST2
	.4byte	0xd0e
	.uleb128 0x30
	.4byte	@.LASF238
	.byte	0x1
	.byte	0xc5
	.4byte	0x681
	.byte	0x1
	.byte	0x50
	.uleb128 0x31
	.string	"map"
	.byte	0x1
	.byte	0xc6
	.4byte	0xd0e
	.byte	0x1
	.byte	0x51
	.uleb128 0x30
	.4byte	@.LASF281
	.byte	0x1
	.byte	0xc6
	.4byte	0x45
	.byte	0x1
	.byte	0x52
	.uleb128 0x31
	.string	"val"
	.byte	0x1
	.byte	0xc6
	.4byte	0x45
	.byte	0x1
	.byte	0x5c
	.uleb128 0x31
	.string	"reg"
	.byte	0x1
	.byte	0xc7
	.4byte	0xa88
	.byte	0x1
	.byte	0x54
	.uleb128 0x30
	.4byte	@.LASF282
	.byte	0x1
	.byte	0xc7
	.4byte	0xd14
	.byte	0x1
	.byte	0x53
	.uleb128 0x30
	.4byte	@.LASF283
	.byte	0x1
	.byte	0xc8
	.4byte	0xd14
	.byte	0x1
	.byte	0x56
	.uleb128 0x32
	.string	"i"
	.byte	0x1
	.byte	0xca
	.4byte	0x45
	.byte	0x1
	.byte	0x55
	.uleb128 0x33
	.4byte	@.LASF264
	.4byte	0xd2f
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	@__func__.16138
	.uleb128 0x34
	.4byte	@.Ldebug_ranges0+0x18
	.uleb128 0x35
	.4byte	@.LASF284
	.byte	0x1
	.byte	0xd4
	.4byte	0xb4
	.byte	0x5
	.byte	0x3
	.4byte	@descriptor.16137
	.byte	0x0
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x72d
	.uleb128 0xf
	.byte	0x4
	.4byte	0xd1a
	.uleb128 0x24
	.4byte	0x85
	.uleb128 0x14
	.4byte	0x85
	.4byte	0xd2f
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x1a
	.byte	0x0
	.uleb128 0x24
	.4byte	0xd1f
	.uleb128 0x2f
	.4byte	@.LASF286
	.byte	0x1
	.byte	0xd8
	.byte	0x1
	.4byte	@.LFB857
	.4byte	@.LFE857
	.4byte	@.LLST3
	.4byte	0xd9b
	.uleb128 0x30
	.4byte	@.LASF238
	.byte	0x1
	.byte	0xd8
	.4byte	0x681
	.byte	0x1
	.byte	0x5d
	.uleb128 0x35
	.4byte	@.LASF240
	.byte	0x1
	.byte	0xda
	.4byte	0xd9b
	.byte	0x1
	.byte	0x52
	.uleb128 0x21
	.4byte	@.LASF287
	.byte	0x1
	.byte	0xdb
	.4byte	0xda1
	.uleb128 0x32
	.string	"ret"
	.byte	0x1
	.byte	0xdc
	.4byte	0x45
	.byte	0x1
	.byte	0x52
	.uleb128 0x35
	.4byte	@.LASF288
	.byte	0x1
	.byte	0xdc
	.4byte	0x45
	.byte	0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x35
	.4byte	@.LASF289
	.byte	0x1
	.byte	0xdc
	.4byte	0x45
	.byte	0x2
	.byte	0x91
	.sleb128 -28
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x693
	.uleb128 0xf
	.byte	0x4
	.4byte	0x68d
	.uleb128 0x28
	.4byte	@.LASF291
	.byte	0x1
	.2byte	0x1ec
	.byte	0x1
	.4byte	0x45
	.4byte	@.LFB865
	.4byte	@.LFE865
	.4byte	@.LLST4
	.4byte	0xfb4
	.uleb128 0x29
	.4byte	@.LASF252
	.byte	0x1
	.2byte	0x1ec
	.4byte	0xa4b
	.byte	0x1
	.byte	0x5f
	.uleb128 0x2a
	.4byte	@.LASF238
	.byte	0x1
	.2byte	0x1ee
	.4byte	0x681
	.byte	0x1
	.byte	0x5e
	.uleb128 0x22
	.4byte	@.LASF240
	.byte	0x1
	.2byte	0x1ef
	.4byte	0xd9b
	.uleb128 0x2a
	.4byte	@.LASF292
	.byte	0x1
	.2byte	0x1f0
	.4byte	0xc62
	.byte	0x1
	.byte	0x5d
	.uleb128 0x36
	.string	"usb"
	.byte	0x1
	.2byte	0x1f1
	.4byte	0xfb4
	.byte	0x1
	.byte	0x64
	.uleb128 0x2a
	.4byte	@.LASF242
	.byte	0x1
	.2byte	0x1f2
	.4byte	0xfb4
	.byte	0x1
	.byte	0x65
	.uleb128 0x2a
	.4byte	@.LASF241
	.byte	0x1
	.2byte	0x1f3
	.4byte	0xfb4
	.byte	0x1
	.byte	0x63
	.uleb128 0x36
	.string	"ret"
	.byte	0x1
	.2byte	0x1f4
	.4byte	0x45
	.byte	0x2
	.byte	0x8c
	.sleb128 4
	.uleb128 0x1d
	.string	"irq"
	.byte	0x1
	.2byte	0x1f4
	.4byte	0x45
	.uleb128 0x36
	.string	"i"
	.byte	0x1
	.2byte	0x1f4
	.4byte	0x45
	.byte	0x1
	.byte	0x60
	.uleb128 0x37
	.4byte	@.LASF293
	.byte	0x1
	.2byte	0x26f
	.4byte	@.L34
	.uleb128 0x37
	.4byte	@.LASF294
	.byte	0x1
	.2byte	0x26d
	.4byte	@.L35
	.uleb128 0x37
	.4byte	@.LASF295
	.byte	0x1
	.2byte	0x26b
	.4byte	@.L37
	.uleb128 0x37
	.4byte	@.LASF296
	.byte	0x1
	.2byte	0x268
	.4byte	@.L39
	.uleb128 0x37
	.4byte	@.LASF297
	.byte	0x1
	.2byte	0x265
	.4byte	@.L42
	.uleb128 0x38
	.4byte	@.LASF347
	.byte	0x1
	.2byte	0x25e
	.uleb128 0x2b
	.4byte	0x9fc
	.4byte	@.LBB178
	.4byte	@.Ldebug_ranges0+0x38
	.byte	0x1
	.2byte	0x1f6
	.4byte	0xef4
	.uleb128 0x2c
	.4byte	0xa1a
	.uleb128 0x2c
	.4byte	0xa0e
	.uleb128 0x39
	.4byte	0x9c3
	.4byte	@.LBB179
	.4byte	@.Ldebug_ranges0+0x50
	.byte	0x4
	.2byte	0x27e
	.uleb128 0x2c
	.4byte	0x9e1
	.uleb128 0x2c
	.4byte	0x9d5
	.uleb128 0x34
	.4byte	@.Ldebug_ranges0+0x68
	.uleb128 0x3a
	.4byte	0x9ee
	.uleb128 0x39
	.4byte	0x988
	.4byte	@.LBB181
	.4byte	@.Ldebug_ranges0+0x80
	.byte	0x4
	.2byte	0x191
	.uleb128 0x2c
	.4byte	0x99a
	.uleb128 0x2c
	.4byte	0x9b0
	.uleb128 0x2c
	.4byte	0x9a4
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.uleb128 0x2b
	.4byte	0xa27
	.4byte	@.LBB188
	.4byte	@.Ldebug_ranges0+0x98
	.byte	0x1
	.2byte	0x1fb
	.4byte	0xf13
	.uleb128 0x2c
	.4byte	0xa3f
	.uleb128 0x2c
	.4byte	0xa34
	.byte	0x0
	.uleb128 0x3b
	.4byte	@.LBB192
	.4byte	@.LBE192
	.uleb128 0x2b
	.4byte	0x782
	.4byte	@.LBB193
	.4byte	@.Ldebug_ranges0+0xb0
	.byte	0x1
	.2byte	0x238
	.4byte	0xf3b
	.uleb128 0x2c
	.4byte	0x7a0
	.uleb128 0x2c
	.4byte	0x794
	.byte	0x0
	.uleb128 0x2d
	.4byte	0x782
	.4byte	@.LBB197
	.4byte	@.LBE197
	.byte	0x1
	.2byte	0x242
	.4byte	0xf5a
	.uleb128 0x2c
	.4byte	0x7a0
	.uleb128 0x2c
	.4byte	0x794
	.byte	0x0
	.uleb128 0x2b
	.4byte	0x782
	.4byte	@.LBB199
	.4byte	@.Ldebug_ranges0+0xc8
	.byte	0x1
	.2byte	0x24d
	.4byte	0xf79
	.uleb128 0x2c
	.4byte	0x7a0
	.uleb128 0x2c
	.4byte	0x794
	.byte	0x0
	.uleb128 0x2d
	.4byte	0x782
	.4byte	@.LBB203
	.4byte	@.LBE203
	.byte	0x1
	.2byte	0x263
	.4byte	0xf98
	.uleb128 0x2c
	.4byte	0x7a0
	.uleb128 0x2c
	.4byte	0x794
	.byte	0x0
	.uleb128 0x2e
	.4byte	0x782
	.4byte	@.LBB205
	.4byte	@.LBE205
	.byte	0x1
	.2byte	0x266
	.uleb128 0x2c
	.4byte	0x7a0
	.uleb128 0x2c
	.4byte	0x794
	.byte	0x0
	.byte	0x0
	.uleb128 0xf
	.byte	0x4
	.4byte	0x4c9
	.uleb128 0x28
	.4byte	@.LASF298
	.byte	0x1
	.2byte	0x1bc
	.byte	0x1
	.4byte	0x5a3
	.4byte	@.LFB862
	.4byte	@.LFE862
	.4byte	@.LLST5
	.4byte	0x1038
	.uleb128 0x3c
	.string	"irq"
	.byte	0x1
	.2byte	0x1bc
	.4byte	0x45
	.byte	0x1
	.byte	0x50
	.uleb128 0x29
	.4byte	@.LASF271
	.byte	0x1
	.2byte	0x1bc
	.4byte	0xc0
	.byte	0x1
	.byte	0x51
	.uleb128 0x2a
	.4byte	@.LASF247
	.byte	0x1
	.2byte	0x1be
	.4byte	0xc62
	.byte	0x1
	.byte	0x5d
	.uleb128 0x2a
	.4byte	@.LASF238
	.byte	0x1
	.2byte	0x1bf
	.4byte	0x681
	.byte	0x1
	.byte	0x53
	.uleb128 0x33
	.4byte	@.LASF264
	.4byte	0x1048
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	@__func__.16308
	.uleb128 0x34
	.4byte	@.Ldebug_ranges0+0xe0
	.uleb128 0x2a
	.4byte	@.LASF284
	.byte	0x1
	.2byte	0x1c1
	.4byte	0xb4
	.byte	0x5
	.byte	0x3
	.4byte	@descriptor.16307
	.byte	0x0
	.byte	0x0
	.uleb128 0x14
	.4byte	0x85
	.4byte	0x1048
	.uleb128 0x15
	.4byte	0x27b
	.byte	0xe
	.byte	0x0
	.uleb128 0x24
	.4byte	0x1038
	.uleb128 0x28
	.4byte	@.LASF299
	.byte	0x1
	.2byte	0x1dc
	.byte	0x1
	.4byte	0x5a3
	.4byte	@.LFB864
	.4byte	@.LFE864
	.4byte	@.LLST6
	.4byte	0x10cb
	.uleb128 0x3c
	.string	"irq"
	.byte	0x1
	.2byte	0x1dc
	.4byte	0x45
	.byte	0x1
	.byte	0x50
	.uleb128 0x29
	.4byte	@.LASF271
	.byte	0x1
	.2byte	0x1dc
	.4byte	0xc0
	.byte	0x1
	.byte	0x51
	.uleb128 0x2a
	.4byte	@.LASF247
	.byte	0x1
	.2byte	0x1de
	.4byte	0xc62
	.byte	0x1
	.byte	0x5d
	.uleb128 0x2a
	.4byte	@.LASF238
	.byte	0x1
	.2byte	0x1df
	.4byte	0x681
	.byte	0x1
	.byte	0x53
	.uleb128 0x33
	.4byte	@.LASF264
	.4byte	0x10db
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	@__func__.16336
	.uleb128 0x34
	.4byte	@.Ldebug_ranges0+0xf8
	.uleb128 0x2a
	.4byte	@.LASF284
	.byte	0x1
	.2byte	0x1e1
	.4byte	0xb4
	.byte	0x5
	.byte	0x3
	.4byte	@descriptor.16335
	.byte	0x0
	.byte	0x0
	.uleb128 0x14
	.4byte	0x85
	.4byte	0x10db
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x12
	.byte	0x0
	.uleb128 0x24
	.4byte	0x10cb
	.uleb128 0x28
	.4byte	@.LASF300
	.byte	0x1
	.2byte	0x1d0
	.byte	0x1
	.4byte	0x5a3
	.4byte	@.LFB863
	.4byte	@.LFE863
	.4byte	@.LLST7
	.4byte	0x1132
	.uleb128 0x3c
	.string	"irq"
	.byte	0x1
	.2byte	0x1d0
	.4byte	0x45
	.byte	0x1
	.byte	0x50
	.uleb128 0x29
	.4byte	@.LASF271
	.byte	0x1
	.2byte	0x1d0
	.4byte	0xc0
	.byte	0x1
	.byte	0x51
	.uleb128 0x22
	.4byte	@.LASF247
	.byte	0x1
	.2byte	0x1d2
	.4byte	0xc62
	.uleb128 0x22
	.4byte	@.LASF238
	.byte	0x1
	.2byte	0x1d3
	.4byte	0x681
	.byte	0x0
	.uleb128 0x28
	.4byte	@.LASF301
	.byte	0x1
	.2byte	0x188
	.byte	0x1
	.4byte	0x45
	.4byte	@.LFB861
	.4byte	@.LFE861
	.4byte	@.LLST8
	.4byte	0x128e
	.uleb128 0x3c
	.string	"psy"
	.byte	0x1
	.2byte	0x188
	.4byte	0xfb4
	.byte	0x1
	.byte	0x50
	.uleb128 0x3c
	.string	"psp"
	.byte	0x1
	.2byte	0x189
	.4byte	0x31d
	.byte	0x1
	.byte	0x5f
	.uleb128 0x3c
	.string	"val"
	.byte	0x1
	.2byte	0x18a
	.4byte	0xacc
	.byte	0x1
	.byte	0x5d
	.uleb128 0x22
	.4byte	@.LASF247
	.byte	0x1
	.2byte	0x18c
	.4byte	0xc62
	.uleb128 0x2a
	.4byte	@.LASF238
	.byte	0x1
	.2byte	0x18d
	.4byte	0x681
	.byte	0x1
	.byte	0x5e
	.uleb128 0x36
	.string	"ret"
	.byte	0x1
	.2byte	0x18e
	.4byte	0x45
	.byte	0x1
	.byte	0x50
	.uleb128 0x2d
	.4byte	0xa51
	.4byte	@.LBB211
	.4byte	@.LBE211
	.byte	0x1
	.2byte	0x192
	.4byte	0x11cf
	.uleb128 0x2c
	.4byte	0xa6f
	.uleb128 0x2c
	.4byte	0xa63
	.uleb128 0x3d
	.4byte	@.LBB212
	.4byte	@.LBE212
	.uleb128 0x3a
	.4byte	0xa7b
	.byte	0x0
	.byte	0x0
	.uleb128 0x2d
	.4byte	0xa8e
	.4byte	@.LBB213
	.4byte	@.LBE213
	.byte	0x1
	.2byte	0x195
	.4byte	0x1202
	.uleb128 0x2c
	.4byte	0xab5
	.uleb128 0x2c
	.4byte	0xaaa
	.uleb128 0x2c
	.4byte	0xa9f
	.uleb128 0x3d
	.4byte	@.LBB214
	.4byte	@.LBE214
	.uleb128 0x3a
	.4byte	0xac0
	.byte	0x0
	.byte	0x0
	.uleb128 0x2d
	.4byte	0xad2
	.4byte	@.LBB215
	.4byte	@.LBE215
	.byte	0x1
	.2byte	0x199
	.4byte	0x1235
	.uleb128 0x2c
	.4byte	0xaf9
	.uleb128 0x2c
	.4byte	0xaee
	.uleb128 0x2c
	.4byte	0xae3
	.uleb128 0x3d
	.4byte	@.LBB216
	.4byte	@.LBE216
	.uleb128 0x3a
	.4byte	0xb04
	.byte	0x0
	.byte	0x0
	.uleb128 0x2d
	.4byte	0xb10
	.4byte	@.LBB217
	.4byte	@.LBE217
	.byte	0x1
	.2byte	0x19c
	.4byte	0x1263
	.uleb128 0x2c
	.4byte	0xb2e
	.uleb128 0x2c
	.4byte	0xb22
	.uleb128 0x3d
	.4byte	@.LBB218
	.4byte	@.LBE218
	.uleb128 0x3a
	.4byte	0xb3a
	.byte	0x0
	.byte	0x0
	.uleb128 0x2e
	.4byte	0xb47
	.4byte	@.LBB219
	.4byte	@.LBE219
	.byte	0x1
	.2byte	0x19f
	.uleb128 0x2c
	.4byte	0xb65
	.uleb128 0x2c
	.4byte	0xb59
	.uleb128 0x3d
	.4byte	@.LBB220
	.4byte	@.LBE220
	.uleb128 0x3a
	.4byte	0xb71
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.uleb128 0x3e
	.4byte	@.LASF302
	.byte	0x1
	.byte	0x61
	.byte	0x1
	.4byte	0x45
	.4byte	@.LFB855
	.4byte	@.LFE855
	.4byte	@.LLST9
	.4byte	0x1357
	.uleb128 0x31
	.string	"psy"
	.byte	0x1
	.byte	0x61
	.4byte	0xfb4
	.byte	0x1
	.byte	0x50
	.uleb128 0x31
	.string	"psp"
	.byte	0x1
	.byte	0x62
	.4byte	0x31d
	.byte	0x1
	.byte	0x5e
	.uleb128 0x31
	.string	"val"
	.byte	0x1
	.byte	0x63
	.4byte	0xacc
	.byte	0x1
	.byte	0x5d
	.uleb128 0x21
	.4byte	@.LASF247
	.byte	0x1
	.byte	0x65
	.4byte	0xc62
	.uleb128 0x35
	.4byte	@.LASF238
	.byte	0x1
	.byte	0x66
	.4byte	0x681
	.byte	0x1
	.byte	0x50
	.uleb128 0x32
	.string	"ret"
	.byte	0x1
	.byte	0x67
	.4byte	0x45
	.byte	0x1
	.byte	0x50
	.uleb128 0x3f
	.4byte	0xa8e
	.4byte	@.LBB221
	.4byte	@.LBE221
	.byte	0x1
	.byte	0x6b
	.4byte	0x1328
	.uleb128 0x2c
	.4byte	0xab5
	.uleb128 0x2c
	.4byte	0xaaa
	.uleb128 0x2c
	.4byte	0xa9f
	.uleb128 0x3d
	.4byte	@.LBB222
	.4byte	@.LBE222
	.uleb128 0x3a
	.4byte	0xac0
	.byte	0x0
	.byte	0x0
	.uleb128 0x40
	.4byte	0xad2
	.4byte	@.LBB223
	.4byte	@.LBE223
	.byte	0x1
	.byte	0x6e
	.uleb128 0x2c
	.4byte	0xaf9
	.uleb128 0x2c
	.4byte	0xaee
	.uleb128 0x2c
	.4byte	0xae3
	.uleb128 0x3d
	.4byte	@.LBB224
	.4byte	@.LBE224
	.uleb128 0x3a
	.4byte	0xb04
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.uleb128 0x3e
	.4byte	@.LASF303
	.byte	0x1
	.byte	0x42
	.byte	0x1
	.4byte	0x45
	.4byte	@.LFB854
	.4byte	@.LFE854
	.4byte	@.LLST10
	.4byte	0x1420
	.uleb128 0x31
	.string	"psy"
	.byte	0x1
	.byte	0x42
	.4byte	0xfb4
	.byte	0x1
	.byte	0x50
	.uleb128 0x31
	.string	"psp"
	.byte	0x1
	.byte	0x43
	.4byte	0x31d
	.byte	0x1
	.byte	0x5e
	.uleb128 0x31
	.string	"val"
	.byte	0x1
	.byte	0x44
	.4byte	0xacc
	.byte	0x1
	.byte	0x5d
	.uleb128 0x21
	.4byte	@.LASF247
	.byte	0x1
	.byte	0x46
	.4byte	0xc62
	.uleb128 0x35
	.4byte	@.LASF238
	.byte	0x1
	.byte	0x47
	.4byte	0x681
	.byte	0x1
	.byte	0x50
	.uleb128 0x32
	.string	"ret"
	.byte	0x1
	.byte	0x48
	.4byte	0x45
	.byte	0x1
	.byte	0x50
	.uleb128 0x3f
	.4byte	0xa8e
	.4byte	@.LBB225
	.4byte	@.LBE225
	.byte	0x1
	.byte	0x4c
	.4byte	0x13f1
	.uleb128 0x2c
	.4byte	0xab5
	.uleb128 0x2c
	.4byte	0xaaa
	.uleb128 0x2c
	.4byte	0xa9f
	.uleb128 0x3d
	.4byte	@.LBB226
	.4byte	@.LBE226
	.uleb128 0x3a
	.4byte	0xac0
	.byte	0x0
	.byte	0x0
	.uleb128 0x40
	.4byte	0xad2
	.4byte	@.LBB227
	.4byte	@.LBE227
	.byte	0x1
	.byte	0x4f
	.uleb128 0x2c
	.4byte	0xaf9
	.uleb128 0x2c
	.4byte	0xaee
	.uleb128 0x2c
	.4byte	0xae3
	.uleb128 0x3d
	.4byte	@.LBB228
	.4byte	@.LBE228
	.uleb128 0x3a
	.4byte	0xb04
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.uleb128 0x41
	.4byte	@.LASF348
	.byte	0x1
	.2byte	0x297
	.byte	0x1
	.4byte	0x45
	.4byte	@.LFB867
	.4byte	@.LFE867
	.byte	0x1
	.byte	0x6c
	.uleb128 0x6
	.4byte	@.LASF304
	.byte	0x1
	.uleb128 0x6
	.4byte	@.LASF305
	.byte	0x1
	.uleb128 0x14
	.4byte	0x31d
	.4byte	0x1453
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x1
	.byte	0x0
	.uleb128 0x35
	.4byte	@.LASF306
	.byte	0x1
	.byte	0x59
	.4byte	0x1443
	.byte	0x5
	.byte	0x3
	.4byte	@wm831x_wall_props
	.uleb128 0x35
	.4byte	@.LASF307
	.byte	0x1
	.byte	0x78
	.4byte	0x1443
	.byte	0x5
	.byte	0x3
	.4byte	@wm831x_usb_props
	.uleb128 0x14
	.4byte	0x72d
	.4byte	0x1485
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x3
	.byte	0x0
	.uleb128 0x35
	.4byte	@.LASF308
	.byte	0x1
	.byte	0x86
	.4byte	0x1475
	.byte	0x5
	.byte	0x3
	.4byte	@trickle_ilims
	.uleb128 0x35
	.4byte	@.LASF309
	.byte	0x1
	.byte	0x8d
	.4byte	0x1475
	.byte	0x5
	.byte	0x3
	.4byte	@vsels
	.uleb128 0x14
	.4byte	0x72d
	.4byte	0x14b7
	.uleb128 0x15
	.4byte	0x27b
	.byte	0xf
	.byte	0x0
	.uleb128 0x35
	.4byte	@.LASF310
	.byte	0x1
	.byte	0x94
	.4byte	0x14a7
	.byte	0x5
	.byte	0x3
	.4byte	@fast_ilims
	.uleb128 0x14
	.4byte	0x72d
	.4byte	0x14d8
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x7
	.byte	0x0
	.uleb128 0x35
	.4byte	@.LASF311
	.byte	0x1
	.byte	0xa7
	.4byte	0x14c8
	.byte	0x5
	.byte	0x3
	.4byte	@eoc_iterms
	.uleb128 0x35
	.4byte	@.LASF312
	.byte	0x1
	.byte	0xb2
	.4byte	0x14a7
	.byte	0x5
	.byte	0x3
	.4byte	@chg_times
	.uleb128 0x14
	.4byte	0x31d
	.4byte	0x150a
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x4
	.byte	0x0
	.uleb128 0x2a
	.4byte	@.LASF313
	.byte	0x1
	.2byte	0x1a9
	.4byte	0x14fa
	.byte	0x5
	.byte	0x3
	.4byte	@wm831x_bat_props
	.uleb128 0x14
	.4byte	0xd14
	.4byte	0x152c
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x7
	.byte	0x0
	.uleb128 0x2a
	.4byte	@.LASF314
	.byte	0x1
	.2byte	0x1b1
	.4byte	0x153e
	.byte	0x5
	.byte	0x3
	.4byte	@wm831x_bat_irqs
	.uleb128 0x24
	.4byte	0x151c
	.uleb128 0x2a
	.4byte	@.LASF315
	.byte	0x1
	.2byte	0x28f
	.4byte	0x290
	.byte	0x5
	.byte	0x3
	.4byte	@wm831x_power_driver
	.uleb128 0x14
	.4byte	0x85
	.4byte	0x1565
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x30
	.byte	0x0
	.uleb128 0x2a
	.4byte	@.LASF316
	.byte	0x1
	.2byte	0x299
	.4byte	0x1577
	.byte	0x5
	.byte	0x3
	.4byte	@__UNIQUE_ID_description0
	.uleb128 0x24
	.4byte	0x1555
	.uleb128 0x14
	.4byte	0x85
	.4byte	0x158c
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x37
	.byte	0x0
	.uleb128 0x2a
	.4byte	@.LASF317
	.byte	0x1
	.2byte	0x29a
	.4byte	0x159e
	.byte	0x5
	.byte	0x3
	.4byte	@__UNIQUE_ID_author1
	.uleb128 0x24
	.4byte	0x157c
	.uleb128 0x14
	.4byte	0x85
	.4byte	0x15b3
	.uleb128 0x15
	.4byte	0x27b
	.byte	0xb
	.byte	0x0
	.uleb128 0x2a
	.4byte	@.LASF318
	.byte	0x1
	.2byte	0x29b
	.4byte	0x15c5
	.byte	0x5
	.byte	0x3
	.4byte	@__UNIQUE_ID_license2
	.uleb128 0x24
	.4byte	0x15a3
	.uleb128 0x14
	.4byte	0x85
	.4byte	0x15da
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x1b
	.byte	0x0
	.uleb128 0x2a
	.4byte	@.LASF319
	.byte	0x1
	.2byte	0x29c
	.4byte	0x15ec
	.byte	0x5
	.byte	0x3
	.4byte	@__UNIQUE_ID_alias3
	.uleb128 0x24
	.4byte	0x15ca
	.uleb128 0x42
	.4byte	@.LASF320
	.byte	0x14
	.byte	0x15
	.4byte	0x15ff
	.byte	0x1
	.byte	0x1
	.byte	0x69
	.uleb128 0xf
	.byte	0x4
	.4byte	0x1437
	.uleb128 0x43
	.4byte	@.LASF321
	.byte	0x15
	.byte	0x21
	.4byte	0x27e
	.byte	0x1
	.byte	0x1
	.uleb128 0x14
	.4byte	0x45
	.4byte	0x161d
	.uleb128 0x44
	.byte	0x0
	.uleb128 0x43
	.4byte	@.LASF322
	.byte	0x16
	.byte	0x24
	.4byte	0x1612
	.byte	0x1
	.byte	0x1
	.uleb128 0x14
	.4byte	0x85
	.4byte	0x1635
	.uleb128 0x44
	.byte	0x0
	.uleb128 0x45
	.4byte	@.LASF323
	.byte	0x17
	.2byte	0x1af
	.4byte	0x1643
	.byte	0x1
	.byte	0x1
	.uleb128 0x24
	.4byte	0x162a
	.uleb128 0x43
	.4byte	@.LASF324
	.byte	0x18
	.byte	0x76
	.4byte	0x8c
	.byte	0x1
	.byte	0x1
	.uleb128 0x43
	.4byte	@.LASF325
	.byte	0x8
	.byte	0x4c
	.4byte	0x45
	.byte	0x1
	.byte	0x1
	.uleb128 0x43
	.4byte	@.LASF326
	.byte	0x19
	.byte	0xa
	.4byte	0x45
	.byte	0x1
	.byte	0x1
	.uleb128 0x43
	.4byte	@.LASF327
	.byte	0x1a
	.byte	0x1c
	.4byte	0x45
	.byte	0x1
	.byte	0x1
	.uleb128 0x14
	.4byte	0x73
	.4byte	0x1692
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x20
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x0
	.byte	0x0
	.uleb128 0x45
	.4byte	@.LASF328
	.byte	0x1a
	.2byte	0x2f9
	.4byte	0x16a0
	.byte	0x1
	.byte	0x1
	.uleb128 0x24
	.4byte	0x167c
	.uleb128 0x43
	.4byte	@.LASF329
	.byte	0x1b
	.byte	0xca
	.4byte	0x45
	.byte	0x1
	.byte	0x1
	.uleb128 0x45
	.4byte	@.LASF330
	.byte	0x1c
	.2byte	0x177
	.4byte	0x16c0
	.byte	0x1
	.byte	0x1
	.uleb128 0xf
	.byte	0x4
	.4byte	0x143d
	.uleb128 0x45
	.4byte	@.LASF331
	.byte	0x1c
	.2byte	0x17a
	.4byte	0x16c0
	.byte	0x1
	.byte	0x1
	.uleb128 0x45
	.4byte	@.LASF332
	.byte	0x8
	.2byte	0x38f
	.4byte	0x250
	.byte	0x1
	.byte	0x1
	.uleb128 0x14
	.4byte	0x73
	.4byte	0x16f2
	.uleb128 0x15
	.4byte	0x27b
	.byte	0x1
	.byte	0x0
	.uleb128 0x43
	.4byte	@.LASF333
	.byte	0x1d
	.byte	0x12
	.4byte	0x16e2
	.byte	0x1
	.byte	0x1
	.uleb128 0x43
	.4byte	@.LASF334
	.byte	0x1e
	.byte	0x8a
	.4byte	0x284
	.byte	0x1
	.byte	0x1
	.uleb128 0x14
	.4byte	0x9bd
	.4byte	0x171c
	.uleb128 0x15
	.4byte	0x27b
	.byte	0xe
	.byte	0x0
	.uleb128 0x43
	.4byte	@.LASF335
	.byte	0x4
	.byte	0xef
	.4byte	0x170c
	.byte	0x1
	.byte	0x1
	.uleb128 0x43
	.4byte	@.LASF336
	.byte	0x1f
	.byte	0x15
	.4byte	0x85
	.byte	0x1
	.byte	0x1
	.uleb128 0x43
	.4byte	@.LASF337
	.byte	0x1f
	.byte	0x15
	.4byte	0x1743
	.byte	0x1
	.byte	0x1
	.uleb128 0xf
	.byte	0x4
	.4byte	0xba
	.uleb128 0x45
	.4byte	@.LASF338
	.byte	0xd
	.2byte	0x14f
	.4byte	0x85
	.byte	0x1
	.byte	0x1
	.uleb128 0x45
	.4byte	@.LASF339
	.byte	0xe
	.2byte	0x187
	.4byte	0x85
	.byte	0x1
	.byte	0x1
	.uleb128 0x45
	.4byte	@.LASF340
	.byte	0xe
	.2byte	0x189
	.4byte	0x85
	.byte	0x1
	.byte	0x1
	.uleb128 0x45
	.4byte	@.LASF341
	.byte	0xe
	.2byte	0x189
	.4byte	0x15ff
	.byte	0x1
	.byte	0x1
	.byte	0x0
	.section	.debug_abbrev
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x55
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x6
	.byte	0x0
	.byte	0x0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0x0
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0x0
	.byte	0x0
	.uleb128 0x4
	.uleb128 0x16
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x5
	.uleb128 0x16
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x6
	.uleb128 0x13
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0xc
	.byte	0x0
	.byte	0x0
	.uleb128 0x7
	.uleb128 0xf
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0x0
	.byte	0x0
	.uleb128 0x8
	.uleb128 0x4
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x9
	.uleb128 0x28
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0x0
	.byte	0x0
	.uleb128 0xa
	.uleb128 0x4
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0xb
	.uleb128 0x4
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0xc
	.uleb128 0x24
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.byte	0x0
	.byte	0x0
	.uleb128 0xd
	.uleb128 0x17
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0xc
	.byte	0x0
	.byte	0x0
	.uleb128 0xe
	.uleb128 0x4
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0xf
	.uleb128 0xf
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x10
	.uleb128 0x26
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.uleb128 0x11
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x12
	.uleb128 0xd
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x13
	.uleb128 0xd
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x14
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x15
	.uleb128 0x21
	.byte	0x0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0x0
	.byte	0x0
	.uleb128 0x16
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x18
	.uleb128 0x5
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x19
	.uleb128 0x26
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x1a
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x1b
	.uleb128 0x5
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x1c
	.uleb128 0x5
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x1d
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x1e
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x1f
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x20
	.uleb128 0x5
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x21
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x22
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x23
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x34
	.uleb128 0xc
	.uleb128 0x1c
	.uleb128 0xe
	.byte	0x0
	.byte	0x0
	.uleb128 0x24
	.uleb128 0x26
	.byte	0x0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x25
	.uleb128 0xb
	.byte	0x1
	.byte	0x0
	.byte	0x0
	.uleb128 0x26
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x27
	.uleb128 0x2e
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x28
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x29
	.uleb128 0x5
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x2a
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x2b
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x55
	.uleb128 0x6
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x2c
	.uleb128 0x5
	.byte	0x0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x2d
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x2e
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0x5
	.byte	0x0
	.byte	0x0
	.uleb128 0x2f
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x30
	.uleb128 0x5
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x31
	.uleb128 0x5
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x32
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x33
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x34
	.uleb128 0xc
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x34
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x6
	.byte	0x0
	.byte	0x0
	.uleb128 0x35
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x36
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x37
	.uleb128 0xa
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x11
	.uleb128 0x1
	.byte	0x0
	.byte	0x0
	.uleb128 0x38
	.uleb128 0xa
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.byte	0x0
	.byte	0x0
	.uleb128 0x39
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x55
	.uleb128 0x6
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0x5
	.byte	0x0
	.byte	0x0
	.uleb128 0x3a
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0x0
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x0
	.byte	0x0
	.uleb128 0x3c
	.uleb128 0x5
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x3d
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x0
	.byte	0x0
	.uleb128 0x3e
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x3f
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x40
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.byte	0x0
	.byte	0x0
	.uleb128 0x41
	.uleb128 0x2e
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x42
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x2
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.uleb128 0x43
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3c
	.uleb128 0xc
	.byte	0x0
	.byte	0x0
	.uleb128 0x44
	.uleb128 0x21
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.uleb128 0x45
	.uleb128 0x34
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3c
	.uleb128 0xc
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.section	.debug_pubnames,"",@progbits
	.4byte	0x1b
	.2byte	0x2
	.4byte	@.Ldebug_info0
	.4byte	0x1782
	.4byte	0x15f1
	.string	"curr_arc"
	.4byte	0x0
	.section	.debug_aranges,"",@progbits
	.4byte	0x2c
	.2byte	0x2
	.4byte	@.Ldebug_info0
	.byte	0x4
	.byte	0x0
	.2byte	0x0
	.2byte	0x0
	.4byte	@.Ltext0
	.4byte	@.Letext0-@.Ltext0
	.4byte	@.LFB869
	.4byte	@.LFE869-@.LFB869
	.4byte	@.LFB867
	.4byte	@.LFE867-@.LFB867
	.4byte	0x0
	.4byte	0x0
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.4byte	@.LBB165
	.4byte	@.LBE165
	.4byte	@.LBB168
	.4byte	@.LBE168
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB175
	.4byte	@.LBE175
	.4byte	@.LBB177
	.4byte	@.LBE177
	.4byte	@.LBB176
	.4byte	@.LBE176
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB178
	.4byte	@.LBE178
	.4byte	@.LBB187
	.4byte	@.LBE187
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB179
	.4byte	@.LBE179
	.4byte	@.LBB186
	.4byte	@.LBE186
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB180
	.4byte	@.LBE180
	.4byte	@.LBB185
	.4byte	@.LBE185
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB181
	.4byte	@.LBE181
	.4byte	@.LBB184
	.4byte	@.LBE184
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB188
	.4byte	@.LBE188
	.4byte	@.LBB191
	.4byte	@.LBE191
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB193
	.4byte	@.LBE193
	.4byte	@.LBB196
	.4byte	@.LBE196
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB199
	.4byte	@.LBE199
	.4byte	@.LBB202
	.4byte	@.LBE202
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB207
	.4byte	@.LBE207
	.4byte	@.LBB208
	.4byte	@.LBE208
	.4byte	0x0
	.4byte	0x0
	.4byte	@.LBB209
	.4byte	@.LBE209
	.4byte	@.LBB210
	.4byte	@.LBE210
	.4byte	0x0
	.4byte	0x0
	.4byte	@.Ltext0
	.4byte	@.Letext0
	.4byte	@.LFB869
	.4byte	@.LFE869
	.4byte	@.LFB866
	.4byte	@.LFE866
	.4byte	@.LFB856
	.4byte	@.LFE856
	.4byte	@.LFB857
	.4byte	@.LFE857
	.4byte	@.LFB865
	.4byte	@.LFE865
	.4byte	@.LFB862
	.4byte	@.LFE862
	.4byte	@.LFB864
	.4byte	@.LFE864
	.4byte	@.LFB863
	.4byte	@.LFE863
	.4byte	@.LFB861
	.4byte	@.LFE861
	.4byte	@.LFB855
	.4byte	@.LFE855
	.4byte	@.LFB854
	.4byte	@.LFE854
	.4byte	@.LFB867
	.4byte	@.LFE867
	.4byte	0x0
	.4byte	0x0
	.section	.debug_line
	.4byte	@.LELT0-@.LSLT0
.LSLT0:
	.2byte	0x2
	.4byte	@.LELTP0-@.LASLTP0
.LASLTP0:
	.byte	0x1
	.byte	0x1
	.byte	0xf6
	.byte	0xf5
	.byte	0xa
	.byte	0x0
	.byte	0x1
	.byte	0x1
	.byte	0x1
	.byte	0x1
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.byte	0x1
	.ascii	"include/asm-generic"
	.byte	0
	.ascii	"include/linux"
	.byte	0
	.ascii	"include/linux/mfd/wm831x"
	.byte	0
	.ascii	"drivers/power"
	.byte	0
	.ascii	"/root/linux-next/arch/arc/include/asm"
	.byte	0
	.ascii	"/root/linux-next/include/uapi/asm-generic"
	.byte	0
	.byte	0x0
	.string	"wm831x_power.c"
	.uleb128 0x4
	.uleb128 0x0
	.uleb128 0x0
	.string	"platform_device.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"mfd/wm831x/core.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"slab.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"posix_types.h"
	.uleb128 0x6
	.uleb128 0x0
	.uleb128 0x0
	.string	"types.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"nodemask.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"mmzone.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"percpu.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"power_supply.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"slub_def.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"irqreturn.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"hrtimer.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"interrupt.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"mfd/wm831x/auxadc.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"bitops.h"
	.uleb128 0x5
	.uleb128 0x0
	.uleb128 0x0
	.string	"kmemleak.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"log2.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"getorder.h"
	.uleb128 0x1
	.uleb128 0x0
	.uleb128 0x0
	.string	"current.h"
	.uleb128 0x5
	.uleb128 0x0
	.uleb128 0x0
	.string	"export.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"printk.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"kernel.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"time.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"debug_locks.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"cpumask.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"timer.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"workqueue.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"percpu.h"
	.uleb128 0x1
	.uleb128 0x0
	.uleb128 0x0
	.string	"ioport.h"
	.uleb128 0x2
	.uleb128 0x0
	.uleb128 0x0
	.string	"irq_regs.h"
	.uleb128 0x1
	.uleb128 0x0
	.uleb128 0x0
	.string	"int-ll64.h"
	.uleb128 0x1
	.uleb128 0x0
	.uleb128 0x0
	.byte	0x0
.LELTP0:
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM1
	.byte	0x3
	.sleb128 628
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM2
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM3
	.byte	0x4
	.uleb128 0x2
	.byte	0x3
	.sleb128 -426
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM4
	.byte	0x4
	.uleb128 0x1
	.byte	0x3
	.sleb128 428
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM5
	.byte	0x4
	.uleb128 0x2
	.byte	0x3
	.sleb128 -428
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM6
	.byte	0x4
	.uleb128 0x1
	.byte	0x3
	.sleb128 428
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM7
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM8
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM9
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -210
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM10
	.byte	0x4
	.uleb128 0x1
	.byte	0xe9
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM11
	.byte	0x11
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM12
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM13
	.byte	0x1b
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM14
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -216
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM15
	.byte	0x4
	.uleb128 0x1
	.byte	0xed
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM16
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM17
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -219
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM18
	.byte	0x4
	.uleb128 0x1
	.byte	0xf0
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM19
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM20
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM21
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM22
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM23
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM24
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM25
	.byte	0x3
	.sleb128 -452
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM26
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM27
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM28
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM29
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM30
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM31
	.byte	0x1a
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM32
	.byte	0xe
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM33
	.byte	0x1a
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM34
	.byte	0xe
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM35
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM36
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM37
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM38
	.byte	0x12
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM39
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM40
	.byte	0x12
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM41
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM42
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM43
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM44
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM45
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM46
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM47
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM48
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM49
	.byte	0x19
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM50
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM51
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM52
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM53
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM54
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM55
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM56
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM57
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM58
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM59
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM60
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM61
	.byte	0x19
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM62
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM63
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM64
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM65
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM66
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM67
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM68
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM69
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM70
	.byte	0x19
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM71
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM72
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM73
	.byte	0x1b
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM74
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM75
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM76
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM77
	.byte	0xdd
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM78
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM79
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM80
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM81
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM82
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM83
	.byte	0x4
	.uleb128 0x4
	.byte	0x3
	.sleb128 -160
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM84
	.byte	0x4
	.uleb128 0x1
	.byte	0xb5
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM85
	.byte	0x4
	.uleb128 0x4
	.byte	0x3
	.sleb128 -161
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM86
	.byte	0x4
	.uleb128 0x1
	.byte	0xbd
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM87
	.byte	0x4
	.uleb128 0x2
	.byte	0x3
	.sleb128 -294
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM88
	.byte	0x4
	.uleb128 0x1
	.byte	0x3
	.sleb128 297
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM89
	.byte	0x4
	.uleb128 0x2
	.byte	0x3
	.sleb128 -297
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM90
	.byte	0x4
	.uleb128 0x1
	.byte	0x3
	.sleb128 304
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM91
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM92
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM93
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM94
	.byte	0xf
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM95
	.byte	0x1c
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM96
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM97
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM98
	.byte	0x1b
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM99
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM100
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM101
	.byte	0x11
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM102
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM103
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM104
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM105
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM106
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM107
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM108
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM109
	.byte	0x3
	.sleb128 -34
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM110
	.byte	0x36
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM111
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM112
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM113
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM114
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM115
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM116
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM117
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM118
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM119
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM120
	.byte	0x3
	.sleb128 -45
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM121
	.byte	0x41
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM122
	.byte	0x3
	.sleb128 -45
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM123
	.byte	0x43
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM124
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM125
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM126
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM127
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM128
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM129
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM130
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM131
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM132
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM133
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -143
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM134
	.byte	0x4
	.uleb128 0x1
	.byte	0xa4
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM135
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -144
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM136
	.byte	0x4
	.uleb128 0x1
	.byte	0xa4
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM137
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM138
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM139
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM140
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM141
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -153
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM142
	.byte	0x4
	.uleb128 0x1
	.byte	0xae
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM143
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM144
	.byte	0x1b
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM145
	.byte	0xd
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM146
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM147
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM148
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM149
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -164
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM150
	.byte	0x4
	.uleb128 0x1
	.byte	0xbb
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM151
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -167
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM152
	.byte	0x4
	.uleb128 0x1
	.byte	0xbb
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM153
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM154
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM155
	.byte	0x1f
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM156
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM157
	.byte	0x3
	.sleb128 -21
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM158
	.byte	0x28
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM159
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM160
	.byte	0x12
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM161
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM162
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -186
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM163
	.byte	0x4
	.uleb128 0x1
	.byte	0xcf
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM164
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM165
	.byte	0x4
	.uleb128 0x3
	.byte	0x3
	.sleb128 -189
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM166
	.byte	0x4
	.uleb128 0x1
	.byte	0xd2
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM167
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM168
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM169
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM170
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM171
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM172
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM173
	.byte	0x3
	.sleb128 -181
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM174
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM175
	.byte	0x10
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM176
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM177
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM178
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM179
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM180
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM181
	.byte	0x28
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM182
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM183
	.byte	0x10
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM184
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM185
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM186
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM187
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM188
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM189
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM190
	.byte	0x3
	.sleb128 -25
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM191
	.byte	0x1a
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM192
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM193
	.byte	0x3
	.sleb128 -79
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM194
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM195
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM196
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM197
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM198
	.byte	0x3
	.sleb128 -102
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM199
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM200
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM201
	.byte	0x19
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM202
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM203
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM204
	.byte	0x16
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM205
	.byte	0x1c
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM206
	.byte	0x3
	.sleb128 -283
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM207
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM208
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM209
	.byte	0x22
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM210
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM211
	.byte	0x3
	.sleb128 300
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM212
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM213
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM214
	.byte	0x19
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM215
	.byte	0x19
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM216
	.byte	0x19
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM217
	.byte	0x1a
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM218
	.byte	0xe
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM219
	.byte	0x3
	.sleb128 -44
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM220
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM221
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM222
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM223
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM224
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM225
	.byte	0x61
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM226
	.byte	0x3
	.sleb128 -323
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM227
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM228
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM229
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM230
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM231
	.byte	0x3
	.sleb128 -67
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM232
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM233
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM234
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM235
	.byte	0x1f
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM236
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM237
	.byte	0x51
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM238
	.byte	0x3
	.sleb128 -49
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM239
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM240
	.byte	0x13
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM241
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM242
	.byte	0x18
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM243
	.byte	0x3
	.sleb128 -36
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM244
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM245
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM246
	.byte	0x17
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM247
	.byte	0x1f
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM248
	.byte	0x15
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LM249
	.byte	0x32
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.Letext0
	.byte	0x0
	.uleb128 0x1
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LSM0
	.byte	0x3
	.sleb128 662
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LSM1
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LFE869
	.byte	0x0
	.uleb128 0x1
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LSM2
	.byte	0x3
	.sleb128 662
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LSM3
	.byte	0x1
	.byte	0x0
	.uleb128 0x5
	.byte	0x2
	.4byte	@.LFE867
	.byte	0x0
	.uleb128 0x1
	.byte	0x1
.LELT0:
	.section	.debug_str,"MS",@progbits,1
.LASF155:
	.string	"POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW"
.LASF7:
	.string	"long int"
.LASF149:
	.string	"POWER_SUPPLY_PROP_TEMP"
.LASF300:
	.string	"wm831x_syslo_irq"
.LASF228:
	.string	"WM831X_AUX_WALL"
.LASF237:
	.string	"WM831X_AUX_AUX1"
.LASF236:
	.string	"WM831X_AUX_AUX2"
.LASF49:
	.string	"NR_SLAB_UNRECLAIMABLE"
.LASF297:
	.string	"err_syslo"
.LASF125:
	.string	"POWER_SUPPLY_PROP_POWER_AVG"
.LASF341:
	.string	"ksoftirqd"
.LASF342:
	.string	"GNU C 4.4.7"
.LASF98:
	.string	"POWER_SUPPLY_HEALTH_OVERHEAT"
.LASF211:
	.string	"HRTIMER_BASE_BOOTTIME"
.LASF53:
	.string	"NR_BOUNCE"
.LASF334:
	.string	"ioport_resource"
.LASF19:
	.string	"N_NORMAL_MEMORY"
.LASF106:
	.string	"POWER_SUPPLY_PROP_STATUS"
.LASF37:
	.string	"NR_INACTIVE_ANON"
.LASF296:
	.string	"err_battery"
.LASF322:
	.string	"console_printk"
.LASF223:
	.string	"RCU_SOFTIRQ"
.LASF95:
	.string	"POWER_SUPPLY_CHARGE_TYPE_FAST"
.LASF243:
	.string	"wall_name"
.LASF257:
	.string	"flags"
.LASF182:
	.string	"ALLOC_FROM_PARTIAL"
.LASF52:
	.string	"NR_UNSTABLE_NFS"
.LASF178:
	.string	"FREE_SLOWPATH"
.LASF198:
	.string	"CPU_PARTIAL_FREE"
.LASF302:
	.string	"wm831x_usb_get_prop"
.LASF4:
	.string	"unsigned int"
.LASF187:
	.string	"CPUSLAB_FLUSH"
.LASF23:
	.string	"NR_NODE_STATES"
.LASF219:
	.string	"BLOCK_IOPOLL_SOFTIRQ"
.LASF239:
	.string	"wm831x_battery_pdata"
.LASF148:
	.string	"POWER_SUPPLY_PROP_CAPACITY_LEVEL"
.LASF275:
	.string	"supply"
.LASF188:
	.string	"DEACTIVATE_FULL"
.LASF77:
	.string	"pglist_data"
.LASF15:
	.string	"_ddebug"
.LASF207:
	.string	"irqreturn_t"
.LASF107:
	.string	"POWER_SUPPLY_PROP_CHARGE_TYPE"
.LASF314:
	.string	"wm831x_bat_irqs"
.LASF288:
	.string	"reg1"
.LASF289:
	.string	"reg2"
.LASF83:
	.string	"module"
.LASF96:
	.string	"POWER_SUPPLY_HEALTH_UNKNOWN"
.LASF324:
	.string	"persistent_clock_exist"
.LASF133:
	.string	"POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT"
.LASF303:
	.string	"wm831x_wall_get_prop"
.LASF175:
	.string	"ALLOC_FASTPATH"
.LASF204:
	.string	"IRQ_NONE"
.LASF40:
	.string	"NR_ACTIVE_FILE"
.LASF348:
	.string	"wm831x_power_driver_init"
.LASF344:
	.string	"/root/linux-next"
.LASF101:
	.string	"POWER_SUPPLY_HEALTH_UNSPEC_FAILURE"
.LASF160:
	.string	"POWER_SUPPLY_PROP_SCOPE"
.LASF126:
	.string	"POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN"
.LASF103:
	.string	"POWER_SUPPLY_HEALTH_WATCHDOG_TIMER_EXPIRE"
.LASF276:
	.string	"wm831x_power_read_voltage"
.LASF193:
	.string	"DEACTIVATE_BYPASS"
.LASF272:
	.string	"wm831x_bat_check_status"
.LASF66:
	.string	"LRU_INACTIVE_ANON"
.LASF245:
	.string	"battery_name"
.LASF321:
	.string	"__this_module"
.LASF128:
	.string	"POWER_SUPPLY_PROP_CHARGE_FULL"
.LASF110:
	.string	"POWER_SUPPLY_PROP_ONLINE"
.LASF217:
	.string	"NET_RX_SOFTIRQ"
.LASF247:
	.string	"wm831x_power"
.LASF144:
	.string	"POWER_SUPPLY_PROP_ENERGY_AVG"
.LASF230:
	.string	"WM831X_AUX_USB"
.LASF43:
	.string	"NR_ANON_PAGES"
.LASF62:
	.string	"NR_ANON_TRANSPARENT_HUGEPAGES"
.LASF130:
	.string	"POWER_SUPPLY_PROP_CHARGE_NOW"
.LASF122:
	.string	"POWER_SUPPLY_PROP_CURRENT_NOW"
.LASF306:
	.string	"wm831x_wall_props"
.LASF112:
	.string	"POWER_SUPPLY_PROP_TECHNOLOGY"
.LASF9:
	.string	"__kernel_size_t"
.LASF109:
	.string	"POWER_SUPPLY_PROP_PRESENT"
.LASF281:
	.string	"count"
.LASF267:
	.string	"index"
.LASF6:
	.string	"long long unsigned int"
.LASF290:
	.string	"wm831x_power_remove"
.LASF152:
	.string	"POWER_SUPPLY_PROP_TEMP_AMBIENT"
.LASF162:
	.string	"POWER_SUPPLY_PROP_MANUFACTURER"
.LASF215:
	.string	"TIMER_SOFTIRQ"
.LASF248:
	.string	"chg_map"
.LASF206:
	.string	"IRQ_WAKE_THREAD"
.LASF163:
	.string	"POWER_SUPPLY_PROP_SERIAL_NUMBER"
.LASF87:
	.string	"POWER_SUPPLY_STATUS_UNKNOWN"
.LASF335:
	.string	"kmalloc_caches"
.LASF343:
	.string	"drivers/power/wm831x_power.c"
.LASF35:
	.string	"NR_ALLOC_BATCH"
.LASF331:
	.string	"system_freezable_wq"
.LASF203:
	.string	"irqreturn"
.LASF312:
	.string	"chg_times"
.LASF156:
	.string	"POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG"
.LASF33:
	.string	"zone_stat_item"
.LASF135:
	.string	"POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE"
.LASF161:
	.string	"POWER_SUPPLY_PROP_MODEL_NAME"
.LASF113:
	.string	"POWER_SUPPLY_PROP_CYCLE_COUNT"
.LASF208:
	.string	"hrtimer_base_type"
.LASF151:
	.string	"POWER_SUPPLY_PROP_TEMP_ALERT_MAX"
.LASF32:
	.string	"node_states"
.LASF92:
	.string	"POWER_SUPPLY_CHARGE_TYPE_UNKNOWN"
.LASF108:
	.string	"POWER_SUPPLY_PROP_HEALTH"
.LASF117:
	.string	"POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN"
.LASF308:
	.string	"trickle_ilims"
.LASF309:
	.string	"vsels"
.LASF129:
	.string	"POWER_SUPPLY_PROP_CHARGE_EMPTY"
.LASF292:
	.string	"power"
.LASF166:
	.string	"POWER_SUPPLY_TYPE_BATTERY"
.LASF60:
	.string	"NR_DIRTIED"
.LASF12:
	.string	"_Bool"
.LASF305:
	.string	"workqueue_struct"
.LASF50:
	.string	"NR_PAGETABLE"
.LASF76:
	.string	"NR_WMARK"
.LASF27:
	.string	"MIGRATE_PCPTYPES"
.LASF84:
	.string	"resource"
.LASF249:
	.string	"reg_val"
.LASF244:
	.string	"usb_name"
.LASF284:
	.string	"descriptor"
.LASF328:
	.string	"cpu_bit_bitmap"
.LASF311:
	.string	"eoc_iterms"
.LASF115:
	.string	"POWER_SUPPLY_PROP_VOLTAGE_MIN"
.LASF286:
	.string	"wm831x_config_battery"
.LASF179:
	.string	"FREE_FROZEN"
.LASF318:
	.string	"__UNIQUE_ID_license2"
.LASF150:
	.string	"POWER_SUPPLY_PROP_TEMP_ALERT_MIN"
.LASF216:
	.string	"NET_TX_SOFTIRQ"
.LASF171:
	.string	"POWER_SUPPLY_TYPE_USB_CDP"
.LASF333:
	.string	"__per_cpu_offset"
.LASF145:
	.string	"POWER_SUPPLY_PROP_CAPACITY"
.LASF89:
	.string	"POWER_SUPPLY_STATUS_DISCHARGING"
.LASF68:
	.string	"LRU_INACTIVE_FILE"
.LASF224:
	.string	"NR_SOFTIRQS"
.LASF55:
	.string	"NR_VMSCAN_IMMEDIATE"
.LASF44:
	.string	"NR_FILE_MAPPED"
.LASF10:
	.string	"char"
.LASF25:
	.string	"MIGRATE_RECLAIMABLE"
.LASF41:
	.string	"NR_UNEVICTABLE"
.LASF214:
	.string	"HI_SOFTIRQ"
.LASF94:
	.string	"POWER_SUPPLY_CHARGE_TYPE_TRICKLE"
.LASF26:
	.string	"MIGRATE_MOVABLE"
.LASF229:
	.string	"WM831X_AUX_BATT"
.LASF199:
	.string	"CPU_PARTIAL_NODE"
.LASF146:
	.string	"POWER_SUPPLY_PROP_CAPACITY_ALERT_MIN"
.LASF38:
	.string	"NR_ACTIVE_ANON"
.LASF258:
	.string	"order"
.LASF251:
	.string	"wm831x_irq"
.LASF111:
	.string	"POWER_SUPPLY_PROP_AUTHENTIC"
.LASF271:
	.string	"data"
.LASF139:
	.string	"POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN"
.LASF259:
	.string	"__ilog2_u32"
.LASF235:
	.string	"WM831X_AUX_AUX3"
.LASF234:
	.string	"WM831X_AUX_AUX4"
.LASF238:
	.string	"wm831x"
.LASF201:
	.string	"NR_SLUB_STAT_ITEMS"
.LASF132:
	.string	"POWER_SUPPLY_PROP_CHARGE_COUNTER"
.LASF18:
	.string	"N_ONLINE"
.LASF273:
	.string	"status"
.LASF119:
	.string	"POWER_SUPPLY_PROP_VOLTAGE_AVG"
.LASF82:
	.string	"PCPU_FC_NR"
.LASF212:
	.string	"HRTIMER_BASE_TAI"
.LASF63:
	.string	"NR_FREE_CMA_PAGES"
.LASF338:
	.string	"__pcpu_scope_tick_cpu_device"
.LASF202:
	.string	"kmem_cache"
.LASF185:
	.string	"ALLOC_NODE_MISMATCH"
.LASF153:
	.string	"POWER_SUPPLY_PROP_TEMP_AMBIENT_ALERT_MIN"
.LASF197:
	.string	"CPU_PARTIAL_ALLOC"
.LASF345:
	.string	"power_supply_propval"
.LASF164:
	.string	"power_supply_type"
.LASF304:
	.string	"task_struct"
.LASF20:
	.string	"N_HIGH_MEMORY"
.LASF22:
	.string	"N_CPU"
.LASF5:
	.string	"long long int"
.LASF131:
	.string	"POWER_SUPPLY_PROP_CHARGE_AVG"
.LASF123:
	.string	"POWER_SUPPLY_PROP_CURRENT_AVG"
.LASF279:
	.string	"wm831x_bat_check_type"
.LASF291:
	.string	"wm831x_power_probe"
.LASF176:
	.string	"ALLOC_SLOWPATH"
.LASF347:
	.string	"err_bat_irq"
.LASF270:
	.string	"platform_set_drvdata"
.LASF172:
	.string	"POWER_SUPPLY_TYPE_USB_ACA"
.LASF298:
	.string	"wm831x_bat_irq"
.LASF47:
	.string	"NR_WRITEBACK"
.LASF192:
	.string	"DEACTIVATE_REMOTE_FREES"
.LASF11:
	.string	"bool"
.LASF255:
	.string	"min_count"
.LASF167:
	.string	"POWER_SUPPLY_TYPE_UPS"
.LASF191:
	.string	"DEACTIVATE_TO_TAIL"
.LASF221:
	.string	"SCHED_SOFTIRQ"
.LASF30:
	.string	"MIGRATE_ISOLATE"
.LASF28:
	.string	"MIGRATE_RESERVE"
.LASF195:
	.string	"CMPXCHG_DOUBLE_CPU_FAIL"
.LASF277:
	.string	"wm831x_bat_check_health"
.LASF141:
	.string	"POWER_SUPPLY_PROP_ENERGY_FULL"
.LASF263:
	.string	"kmalloc_index"
.LASF250:
	.string	"platform_get_drvdata"
.LASF168:
	.string	"POWER_SUPPLY_TYPE_MAINS"
.LASF157:
	.string	"POWER_SUPPLY_PROP_TIME_TO_FULL_NOW"
.LASF29:
	.string	"MIGRATE_CMA"
.LASF127:
	.string	"POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN"
.LASF21:
	.string	"N_MEMORY"
.LASF220:
	.string	"TASKLET_SOFTIRQ"
.LASF254:
	.string	"size"
.LASF72:
	.string	"zone_watermarks"
.LASF200:
	.string	"CPU_PARTIAL_DRAIN"
.LASF269:
	.string	"kmemleak_alloc"
.LASF80:
	.string	"PCPU_FC_EMBED"
.LASF232:
	.string	"WM831X_AUX_BATT_TEMP"
.LASF287:
	.string	"pdata"
.LASF165:
	.string	"POWER_SUPPLY_TYPE_UNKNOWN"
.LASF58:
	.string	"NR_ISOLATED_FILE"
.LASF240:
	.string	"wm831x_pdata"
.LASF218:
	.string	"BLOCK_SOFTIRQ"
.LASF340:
	.string	"__pcpu_scope_ksoftirqd"
.LASF252:
	.string	"pdev"
.LASF325:
	.string	"page_group_by_mobility_disabled"
.LASF71:
	.string	"NR_LRU_LISTS"
.LASF65:
	.string	"lru_list"
.LASF231:
	.string	"WM831X_AUX_SYSVDD"
.LASF99:
	.string	"POWER_SUPPLY_HEALTH_DEAD"
.LASF97:
	.string	"POWER_SUPPLY_HEALTH_GOOD"
.LASF332:
	.string	"contig_page_data"
.LASF253:
	.string	"constant_fls"
.LASF13:
	.string	"size_t"
.LASF265:
	.string	"kmem_cache_alloc_trace"
.LASF330:
	.string	"system_wq"
.LASF174:
	.string	"stat_item"
.LASF91:
	.string	"POWER_SUPPLY_STATUS_FULL"
.LASF1:
	.string	"unsigned char"
.LASF190:
	.string	"DEACTIVATE_TO_HEAD"
.LASF210:
	.string	"HRTIMER_BASE_REALTIME"
.LASF262:
	.string	"kmalloc_large"
.LASF36:
	.string	"NR_LRU_BASE"
.LASF116:
	.string	"POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN"
.LASF14:
	.string	"gfp_t"
.LASF2:
	.string	"short int"
.LASF105:
	.string	"power_supply_property"
.LASF56:
	.string	"NR_WRITEBACK_TEMP"
.LASF90:
	.string	"POWER_SUPPLY_STATUS_NOT_CHARGING"
.LASF85:
	.string	"platform_device"
.LASF205:
	.string	"IRQ_HANDLED"
.LASF261:
	.string	"kmalloc_order_trace"
.LASF177:
	.string	"FREE_FASTPATH"
.LASF100:
	.string	"POWER_SUPPLY_HEALTH_OVERVOLTAGE"
.LASF169:
	.string	"POWER_SUPPLY_TYPE_USB"
.LASF268:
	.string	"kzalloc"
.LASF225:
	.string	"wm831x_auxadc"
.LASF170:
	.string	"POWER_SUPPLY_TYPE_USB_DCP"
.LASF102:
	.string	"POWER_SUPPLY_HEALTH_COLD"
.LASF118:
	.string	"POWER_SUPPLY_PROP_VOLTAGE_NOW"
.LASF64:
	.string	"NR_VM_ZONE_STAT_ITEMS"
.LASF278:
	.string	"health"
.LASF39:
	.string	"NR_INACTIVE_FILE"
.LASF323:
	.string	"hex_asc"
.LASF316:
	.string	"__UNIQUE_ID_description0"
.LASF78:
	.string	"pcpu_fc"
.LASF54:
	.string	"NR_VMSCAN_WRITE"
.LASF337:
	.string	"__irq_regs"
.LASF315:
	.string	"wm831x_power_driver"
.LASF81:
	.string	"PCPU_FC_PAGE"
.LASF256:
	.string	"kmalloc_order"
.LASF282:
	.string	"name"
.LASF59:
	.string	"NR_SHMEM"
.LASF326:
	.string	"debug_locks"
.LASF138:
	.string	"POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX"
.LASF260:
	.string	"__get_order"
.LASF274:
	.string	"wm831x_power_check_online"
.LASF186:
	.string	"FREE_SLAB"
.LASF137:
	.string	"POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT"
.LASF120:
	.string	"POWER_SUPPLY_PROP_VOLTAGE_OCV"
.LASF142:
	.string	"POWER_SUPPLY_PROP_ENERGY_EMPTY"
.LASF31:
	.string	"MIGRATE_TYPES"
.LASF339:
	.string	"__pcpu_scope_softirq_work_list"
.LASF8:
	.string	"long unsigned int"
.LASF124:
	.string	"POWER_SUPPLY_PROP_POWER_NOW"
.LASF16:
	.string	"pt_regs"
.LASF346:
	.string	"wm831x_power_driver_exit"
.LASF69:
	.string	"LRU_ACTIVE_FILE"
.LASF301:
	.string	"wm831x_bat_get_prop"
.LASF45:
	.string	"NR_FILE_PAGES"
.LASF181:
	.string	"FREE_REMOVE_PARTIAL"
.LASF17:
	.string	"N_POSSIBLE"
.LASF140:
	.string	"POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN"
.LASF51:
	.string	"NR_KERNEL_STACK"
.LASF42:
	.string	"NR_MLOCK"
.LASF246:
	.string	"have_battery"
.LASF196:
	.string	"CMPXCHG_DOUBLE_FAIL"
.LASF227:
	.string	"WM831X_AUX_BKUP_BATT"
.LASF280:
	.string	"type"
.LASF320:
	.string	"curr_arc"
.LASF233:
	.string	"WM831X_AUX_CHIP_TEMP"
.LASF307:
	.string	"wm831x_usb_props"
.LASF285:
	.string	"wm831x_battey_apply_config"
.LASF158:
	.string	"POWER_SUPPLY_PROP_TIME_TO_FULL_AVG"
.LASF266:
	.string	"kmalloc"
.LASF104:
	.string	"POWER_SUPPLY_HEALTH_SAFETY_TIMER_EXPIRE"
.LASF114:
	.string	"POWER_SUPPLY_PROP_VOLTAGE_MAX"
.LASF310:
	.string	"fast_ilims"
.LASF75:
	.string	"WMARK_HIGH"
.LASF299:
	.string	"wm831x_pwr_src_irq"
.LASF34:
	.string	"NR_FREE_PAGES"
.LASF93:
	.string	"POWER_SUPPLY_CHARGE_TYPE_NONE"
.LASF329:
	.string	"timer_stats_active"
.LASF136:
	.string	"POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX"
.LASF57:
	.string	"NR_ISOLATED_ANON"
.LASF209:
	.string	"HRTIMER_BASE_MONOTONIC"
.LASF313:
	.string	"wm831x_bat_props"
.LASF226:
	.string	"WM831X_AUX_CAL"
.LASF61:
	.string	"NR_WRITTEN"
.LASF48:
	.string	"NR_SLAB_RECLAIMABLE"
.LASF173:
	.string	"power_supply"
.LASF241:
	.string	"wall"
.LASF79:
	.string	"PCPU_FC_AUTO"
.LASF121:
	.string	"POWER_SUPPLY_PROP_CURRENT_MAX"
.LASF194:
	.string	"ORDER_FALLBACK"
.LASF283:
	.string	"units"
.LASF180:
	.string	"FREE_ADD_PARTIAL"
.LASF336:
	.string	"__pcpu_scope___irq_regs"
.LASF0:
	.string	"signed char"
.LASF143:
	.string	"POWER_SUPPLY_PROP_ENERGY_NOW"
.LASF70:
	.string	"LRU_UNEVICTABLE"
.LASF3:
	.string	"short unsigned int"
.LASF147:
	.string	"POWER_SUPPLY_PROP_CAPACITY_ALERT_MAX"
.LASF134:
	.string	"POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX"
.LASF293:
	.string	"err_kmalloc"
.LASF317:
	.string	"__UNIQUE_ID_author1"
.LASF264:
	.string	"__func__"
.LASF67:
	.string	"LRU_ACTIVE_ANON"
.LASF183:
	.string	"ALLOC_SLAB"
.LASF327:
	.string	"nr_cpu_ids"
.LASF295:
	.string	"err_usb"
.LASF184:
	.string	"ALLOC_REFILL"
.LASF242:
	.string	"battery"
.LASF86:
	.string	"platform_driver"
.LASF88:
	.string	"POWER_SUPPLY_STATUS_CHARGING"
.LASF24:
	.string	"MIGRATE_UNMOVABLE"
.LASF46:
	.string	"NR_FILE_DIRTY"
.LASF213:
	.string	"HRTIMER_MAX_CLOCK_BASES"
.LASF154:
	.string	"POWER_SUPPLY_PROP_TEMP_AMBIENT_ALERT_MAX"
.LASF294:
	.string	"err_wall"
.LASF222:
	.string	"HRTIMER_SOFTIRQ"
.LASF159:
	.string	"POWER_SUPPLY_PROP_TYPE"
.LASF73:
	.string	"WMARK_MIN"
.LASF189:
	.string	"DEACTIVATE_EMPTY"
.LASF74:
	.string	"WMARK_LOW"
.LASF319:
	.string	"__UNIQUE_ID_alias3"
	.ident	"GCC: (ARCompact elf32 toolchain (built 20130922)) 4.4.7"

--------------000508040008000408060905--

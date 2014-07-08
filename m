Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaGHQA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:00:57 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44045 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaGHQAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:00:55 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: linux-kernel@vger.kernel.org
Subject: next-20140707 - crash during cryptsetup.
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1404835247_1910P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Jul 2014 12:00:47 -0400
Message-ID: <6964.1404835247@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1404835247_1910P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Not sure *who* to pin this one on, so drop it on lkml and see who notices=
...

next-20140701 works just fine.

System died a horrid death when cryptsetup was trying to get an encrypted=

disk up and running.  This ring any bells?  If not, I'll probably spend p=
art
of the evening bisecting...


=5B   25.929846=5D ------------=5B cut here =5D------------
=5B   25.929873=5D kernel BUG at fs/direct-io.c:747=21
=5B   25.929893=5D invalid opcode: 0000 =5B=231=5D PREEMPT SMP=20
=5B   25.929922=5D Modules linked in:
=5B   25.929940=5D CPU: 3 PID: 308 Comm: systemd-cryptse Not tainted 3.16=
.0-rc4-next-20140707 =23247
=5B   25.929974=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B   25.930004=5D task: ffff880222609e50 ti: ffff8802225b4000 task.ti: f=
fff8802225b4000
=5B   25.930034=5D RIP: 0010:=5B<ffffffff8116bee5>=5D  =5B<ffffffff8116be=
e5>=5D dio_send_cur_page+0xd7/0xe3
=5B   25.930074=5D RSP: 0018:ffff8802225b7aa0  EFLAGS: 00010202
=5B   25.930096=5D RAX: 0000000000000001 RBX: ffff8802225b7c01 RCX: 00000=
00000000000
=5B   25.930126=5D RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffff=
fff81d13cf0
=5B   25.930155=5D RBP: ffff8802225b7ac8 R08: 0000000000000000 R09: 00000=
00000000001
=5B   25.930184=5D R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
800c6e8dc00
=5B   25.930213=5D R13: ffff8802225b7bc0 R14: 000000000000007a R15: 00000=
0000000007c
=5B   25.930243=5D FS:  00007f5908c49840(0000) GS:ffff88022dd80000(0000) =
knlGS:0000000000000000
=5B   25.930276=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B   25.930300=5D CR2: 00000000006ecf18 CR3: 0000000222bb1000 CR4: 00000=
000001407e0
=5B   25.930329=5D Stack:
=5B   25.930339=5D  0000000100000000 ffff8800c6e8dc00 ffffea0002ba9d68 00=
00000000000800
=5B   25.930380=5D  ffff8802225b7c28 ffff8802225b7b08 ffffffff8116bfa2 00=
00000022110780
=5B   25.930419=5D  ffff8800c6e8dc00 ffffea0002ba9d68 0000000000000800 00=
00000000000001
=5B   25.930458=5D Call Trace:
=5B   25.930473=5D  =5B<ffffffff8116bfa2>=5D submit_page_section+0xb1/0x1=
14
=5B   25.930499=5D  =5B<ffffffff8116cad6>=5D do_blockdev_direct_IO+0xa28/=
0xd1f
=5B   25.930527=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   25.930549=5D  =5B<ffffffff8116cdfc>=5D __blockdev_direct_IO+0x2f/0x=
31
=5B   25.930575=5D  =5B<ffffffff8116cdfc>=5D ? __blockdev_direct_IO+0x2f/=
0x31
=5B   25.930601=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   25.930622=5D  =5B<ffffffff811698e2>=5D blkdev_direct_IO+0x2e/0x30
=5B   25.930647=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   25.930669=5D  =5B<ffffffff810f314c>=5D generic_file_read_iter+0x93/=
0x5c8
=5B   25.930697=5D  =5B<ffffffff81169c8a>=5D blkdev_read_iter+0x35/0x37
=5B   25.930722=5D  =5B<ffffffff81139725>=5D new_sync_read+0x74/0x98
=5B   25.930746=5D  =5B<ffffffff81139e0c>=5D vfs_read+0xce/0x124
=5B   25.930768=5D  =5B<ffffffff8113a665>=5D SyS_read+0x4b/0x79
=5B   25.930791=5D  =5B<ffffffff8167ea92>=5D system_call_fastpath+0x16/0x=
1b
=5B   25.930816=5D Code: fe ff ff 48 89 df e8 40 fe ff ff 48 c7 c7 f0 3c =
d1 81 85 c0 89 45 dc 0f 95 c3 31 d2 0f b6 f3 e8 4f ad f6 ff 84 db 8b 45 d=
c 74 02 <0f> 0b 5a 5b 41 5c 41 5d 41 5e 5d c3 55 48 89 e5 41 57 4d 89 cf =

=5B   25.931060=5D RIP  =5B<ffffffff8116bee5>=5D dio_send_cur_page+0xd7/0=
xe3
=5B   25.931088=5D  RSP <ffff8802225b7aa0>
=5B   25.931132=5D ---=5B end trace 5bdcfa6254e32464 =5D---
=5B   26.074334=5D ------------=5B cut here =5D------------
=5B   26.074387=5D WARNING: CPU: 1 PID: 308 at kernel/exit.c:669 do_exit+=
0x7c/0xc0c()
=5B   26.074434=5D Modules linked in:
=5B   26.074459=5D CPU: 1 PID: 308 Comm: systemd-cryptse Tainted: G      =
D        3.16.0-rc4-next-20140707 =23247
=5B   26.074509=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B   26.074547=5D  0000000000000000 ffff8802225b77c0 ffffffff816737c4 00=
00000000000000
=5B   26.074599=5D  0000000000000009 ffff8802225b77f8 ffffffff8103d49f ff=
ffffff8103e22a
=5B   26.074649=5D  ffff880222609e50 000000000000000b 0000000000000001 00=
00000000000000
=5B   26.074702=5D Call Trace:
=5B   26.074724=5D  =5B<ffffffff816737c4>=5D dump_stack+0x51/0xaa
=5B   26.074754=5D  =5B<ffffffff8103d49f>=5D warn_slowpath_common+0x7a/0x=
93
=5B   26.076397=5D  =5B<ffffffff8103e22a>=5D ? do_exit+0x7c/0xc0c
=5B   26.078025=5D  =5B<ffffffff8103d55c>=5D warn_slowpath_null+0x15/0x17=

=5B   26.079607=5D  =5B<ffffffff8103e22a>=5D do_exit+0x7c/0xc0c
=5B   26.081174=5D  =5B<ffffffff81087e47>=5D ? __rcu_read_unlock+0xf2/0xf=
9
=5B   26.082734=5D  =5B<ffffffff81081c70>=5D ? kmsg_dump+0xb3/0xb9
=5B   26.084241=5D  =5B<ffffffff8100577f>=5D oops_end+0x7c/0x81
=5B   26.085756=5D  =5B<ffffffff81005ad1>=5D die+0x55/0x5e
=5B   26.087317=5D  =5B<ffffffff810029d3>=5D do_trap+0x64/0x11b
=5B   26.088813=5D  =5B<ffffffff81002b98>=5D do_error_trap+0xbe/0xcd
=5B   26.090262=5D  =5B<ffffffff8116bee5>=5D ? dio_send_cur_page+0xd7/0xe=
3
=5B   26.091748=5D  =5B<ffffffff810d6212>=5D ? time_hardirqs_off+0x1b/0x2=
f
=5B   26.093182=5D  =5B<ffffffff8107737a>=5D ? trace_hardirqs_off_caller+=
0x4c/0xb9
=5B   26.094644=5D  =5B<ffffffff8127c96a>=5D ? trace_hardirqs_off_thunk+0=
x3a/0x3c
=5B   26.096073=5D  =5B<ffffffff810035e1>=5D do_invalid_op+0x1b/0x1d
=5B   26.097514=5D  =5B<ffffffff816803b8>=5D invalid_op+0x18/0x20
=5B   26.098912=5D  =5B<ffffffff8116bee5>=5D ? dio_send_cur_page+0xd7/0xe=
3
=5B   26.100360=5D  =5B<ffffffff8116bfa2>=5D submit_page_section+0xb1/0x1=
14
=5B   26.101740=5D  =5B<ffffffff8116cad6>=5D do_blockdev_direct_IO+0xa28/=
0xd1f
=5B   26.103138=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   26.104526=5D  =5B<ffffffff8116cdfc>=5D __blockdev_direct_IO+0x2f/0x=
31
=5B   26.105867=5D  =5B<ffffffff8116cdfc>=5D ? __blockdev_direct_IO+0x2f/=
0x31
=5B   26.107236=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   26.108591=5D  =5B<ffffffff811698e2>=5D blkdev_direct_IO+0x2e/0x30
=5B   26.109920=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   26.111223=5D  =5B<ffffffff810f314c>=5D generic_file_read_iter+0x93/=
0x5c8
=5B   26.112554=5D  =5B<ffffffff81169c8a>=5D blkdev_read_iter+0x35/0x37
=5B   26.113884=5D  =5B<ffffffff81139725>=5D new_sync_read+0x74/0x98
=5B   26.115203=5D  =5B<ffffffff81139e0c>=5D vfs_read+0xce/0x124
=5B   26.116527=5D  =5B<ffffffff8113a665>=5D SyS_read+0x4b/0x79
=5B   26.117832=5D  =5B<ffffffff8167ea92>=5D system_call_fastpath+0x16/0x=
1b
=5B   26.119128=5D ---=5B end trace 5bdcfa6254e32465 =5D---
=5B   26.127584=5D systemd-cryptse (308) used greatest stack depth: 12536=
 bytes left
=5B   27.535372=5D ------------=5B cut here =5D------------
=5B   27.536703=5D kernel BUG at fs/direct-io.c:747=21
=5B   27.538007=5D invalid opcode: 0000 =5B=232=5D PREEMPT SMP=20
=5B   27.539294=5D Modules linked in:
=5B   27.540558=5D CPU: 2 PID: 376 Comm: systemd-cryptse Tainted: G      =
D W      3.16.0-rc4-next-20140707 =23247
=5B   27.541896=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B   27.543268=5D task: ffff880222869790 ti: ffff88003f9c4000 task.ti: f=
fff88003f9c4000
=5B   27.544643=5D RIP: 0010:=5B<ffffffff8116bee5>=5D  =5B<ffffffff8116be=
e5>=5D dio_send_cur_page+0xd7/0xe3
=5B   27.546154=5D RSP: 0018:ffff88003f9c7aa0  EFLAGS: 00010202
=5B   27.547491=5D RAX: 0000000000000001 RBX: ffff88003f9c7c01 RCX: 00000=
00000000000
=5B   27.548785=5D RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffff=
fff81d13cf0
=5B   27.550033=5D RBP: ffff88003f9c7ac8 R08: 0000000000000000 R09: 00000=
00000000001
=5B   27.551275=5D R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
80222bef900
=5B   27.552525=5D R13: ffff88003f9c7bc0 R14: 000000000000007a R15: 00000=
0000000007c
=5B   27.553766=5D FS:  00007feec4f0c840(0000) GS:ffff88022dd00000(0000) =
knlGS:0000000000000000
=5B   27.555013=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B   27.556258=5D CR2: 00000000006ecf18 CR3: 00000000c6ddc000 CR4: 00000=
000001407e0
=5B   27.557508=5D Stack:
=5B   27.558726=5D  0000000100000000 ffff880222bef900 ffffea0007766478 00=
00000000000800
=5B   27.560013=5D  ffff88003f9c7c28 ffff88003f9c7b08 ffffffff8116bfa2 00=
00000022110780
=5B   27.561525=5D  ffff880222bef900 ffffea0007766478 0000000000000800 00=
00000000000001
=5B   27.562935=5D Call Trace:
=5B   27.564319=5D  =5B<ffffffff8116bfa2>=5D submit_page_section+0xb1/0x1=
14
=5B   27.565725=5D  =5B<ffffffff8116cad6>=5D do_blockdev_direct_IO+0xa28/=
0xd1f
=5B   27.567126=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   27.568529=5D  =5B<ffffffff8116cdfc>=5D __blockdev_direct_IO+0x2f/0x=
31
=5B   27.569930=5D  =5B<ffffffff8116cdfc>=5D ? __blockdev_direct_IO+0x2f/=
0x31
=5B   27.571329=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   27.572731=5D  =5B<ffffffff811698e2>=5D blkdev_direct_IO+0x2e/0x30
=5B   27.574129=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   27.575525=5D  =5B<ffffffff810f314c>=5D generic_file_read_iter+0x93/=
0x5c8
=5B   27.576942=5D  =5B<ffffffff81169c8a>=5D blkdev_read_iter+0x35/0x37
=5B   27.578353=5D  =5B<ffffffff81139725>=5D new_sync_read+0x74/0x98
=5B   27.579765=5D  =5B<ffffffff81139e0c>=5D vfs_read+0xce/0x124
=5B   27.581181=5D  =5B<ffffffff8113a665>=5D SyS_read+0x4b/0x79
=5B   27.582584=5D  =5B<ffffffff8167ea92>=5D system_call_fastpath+0x16/0x=
1b
=5B   27.583988=5D Code: fe ff ff 48 89 df e8 40 fe ff ff 48 c7 c7 f0 3c =
d1 81 85 c0 89 45 dc 0f 95 c3 31 d2 0f b6 f3 e8 4f ad f6 ff 84 db 8b 45 d=
c 74 02 <0f> 0b 5a 5b 41 5c 41 5d 41 5e 5d c3 55 48 89 e5 41 57 4d 89 cf =

=5B   27.585696=5D RIP  =5B<ffffffff8116bee5>=5D dio_send_cur_page+0xd7/0=
xe3
=5B   27.587226=5D  RSP <ffff88003f9c7aa0>
=5B   27.588776=5D ---=5B end trace 5bdcfa6254e32466 =5D---
=5B   27.755641=5D ------------=5B cut here =5D------------
=5B   27.759235=5D WARNING: CPU: 0 PID: 376 at kernel/exit.c:669 do_exit+=
0x7c/0xc0c()
=5B   27.762831=5D Modules linked in:
=5B   27.766154=5D CPU: 0 PID: 376 Comm: systemd-cryptse Tainted: G      =
D W      3.16.0-rc4-next-20140707 =23247
=5B   27.769530=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B   27.772754=5D  0000000000000000 ffff88003f9c77c0 ffffffff816737c4 00=
00000000000000
=5B   27.775700=5D  0000000000000009 ffff88003f9c77f8 ffffffff8103d49f ff=
ffffff8103e22a
=5B   27.778634=5D  ffff880222869790 000000000000000b 0000000000000001 00=
00000000000000
=5B   27.781592=5D Call Trace:
=5B   27.784482=5D  =5B<ffffffff816737c4>=5D dump_stack+0x51/0xaa
=5B   27.787423=5D  =5B<ffffffff8103d49f>=5D warn_slowpath_common+0x7a/0x=
93
=5B   27.790254=5D  =5B<ffffffff8103e22a>=5D ? do_exit+0x7c/0xc0c
=5B   27.793054=5D  =5B<ffffffff8103d55c>=5D warn_slowpath_null+0x15/0x17=

=5B   27.795868=5D  =5B<ffffffff8103e22a>=5D do_exit+0x7c/0xc0c
=5B   27.798660=5D  =5B<ffffffff81087e47>=5D ? __rcu_read_unlock+0xf2/0xf=
9
=5B   27.801420=5D  =5B<ffffffff81081c70>=5D ? kmsg_dump+0xb3/0xb9
=5B   27.804079=5D  =5B<ffffffff8100577f>=5D oops_end+0x7c/0x81
=5B   27.806686=5D  =5B<ffffffff81005ad1>=5D die+0x55/0x5e
=5B   27.809243=5D  =5B<ffffffff810029d3>=5D do_trap+0x64/0x11b
=5B   27.811749=5D  =5B<ffffffff81002b98>=5D do_error_trap+0xbe/0xcd
=5B   27.814137=5D  =5B<ffffffff8116bee5>=5D ? dio_send_cur_page+0xd7/0xe=
3
=5B   27.816491=5D  =5B<ffffffff810d6212>=5D ? time_hardirqs_off+0x1b/0x2=
f
=5B   27.818796=5D  =5B<ffffffff81680883>=5D ? error_sti+0x5/0x6
=5B   27.821004=5D  =5B<ffffffff8107734d>=5D ? trace_hardirqs_off_caller+=
0x1f/0xb9
=5B   27.823176=5D  =5B<ffffffff8127c96a>=5D ? trace_hardirqs_off_thunk+0=
x3a/0x3c
=5B   27.825242=5D  =5B<ffffffff810035e1>=5D do_invalid_op+0x1b/0x1d
=5B   27.827264=5D  =5B<ffffffff816803b8>=5D invalid_op+0x18/0x20
=5B   27.829268=5D  =5B<ffffffff8116bee5>=5D ? dio_send_cur_page+0xd7/0xe=
3
=5B   27.831262=5D  =5B<ffffffff8116bfa2>=5D submit_page_section+0xb1/0x1=
14
=5B   27.833285=5D  =5B<ffffffff8116cad6>=5D do_blockdev_direct_IO+0xa28/=
0xd1f
=5B   27.835329=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   27.837253=5D  =5B<ffffffff8116cdfc>=5D __blockdev_direct_IO+0x2f/0x=
31
=5B   27.839142=5D  =5B<ffffffff8116cdfc>=5D ? __blockdev_direct_IO+0x2f/=
0x31
=5B   27.841022=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   27.842867=5D  =5B<ffffffff811698e2>=5D blkdev_direct_IO+0x2e/0x30
=5B   27.844680=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   27.846475=5D  =5B<ffffffff810f314c>=5D generic_file_read_iter+0x93/=
0x5c8
=5B   27.848252=5D  =5B<ffffffff81169c8a>=5D blkdev_read_iter+0x35/0x37
=5B   27.850005=5D  =5B<ffffffff81139725>=5D new_sync_read+0x74/0x98
=5B   27.851755=5D  =5B<ffffffff81139e0c>=5D vfs_read+0xce/0x124
=5B   27.853481=5D  =5B<ffffffff8113a665>=5D SyS_read+0x4b/0x79
=5B   27.855180=5D  =5B<ffffffff8167ea92>=5D system_call_fastpath+0x16/0x=
1b
=5B   27.856901=5D ---=5B end trace 5bdcfa6254e32467 =5D---
=5B   29.288222=5D ------------=5B cut here =5D------------
=5B   29.289487=5D kernel BUG at fs/direct-io.c:747=21
=5B   29.290728=5D invalid opcode: 0000 =5B=233=5D PREEMPT SMP=20
=5B   29.291979=5D Modules linked in:
=5B   29.293217=5D CPU: 1 PID: 421 Comm: systemd-cryptse Tainted: G      =
D W      3.16.0-rc4-next-20140707 =23247
=5B   29.294496=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B   29.295799=5D task: ffff88022245c310 ti: ffff8802226d4000 task.ti: f=
fff8802226d4000
=5B   29.297087=5D RIP: 0010:=5B<ffffffff8116bee5>=5D  =5B<ffffffff8116be=
e5>=5D dio_send_cur_page+0xd7/0xe3
=5B   29.298398=5D RSP: 0018:ffff8802226d7aa0  EFLAGS: 00010202
=5B   29.299709=5D RAX: 0000000000000001 RBX: ffff8802226d7c01 RCX: 00000=
00000000000
=5B   29.301029=5D RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffff=
fff81d13cf0
=5B   29.302355=5D RBP: ffff8802226d7ac8 R08: 0000000000000000 R09: 00000=
00000000001
=5B   29.303685=5D R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
80222bee040
=5B   29.304968=5D R13: ffff8802226d7bc0 R14: 000000000000007a R15: 00000=
0000000007c
=5B   29.306194=5D FS:  00007f09fd985840(0000) GS:ffff88022dc80000(0000) =
knlGS:0000000000000000
=5B   29.307436=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B   29.308722=5D CR2: 00007f0f8b743148 CR3: 0000000222b38000 CR4: 00000=
000001407e0
=5B   29.310080=5D Stack:
=5B   29.311307=5D  0000000100000000 ffff880222bee040 ffffea00000511d8 00=
00000000000800
=5B   29.312562=5D  ffff8802226d7c28 ffff8802226d7b08 ffffffff8116bfa2 00=
00000022110780
=5B   29.313805=5D  ffff880222bee040 ffffea00000511d8 0000000000000800 00=
00000000000001
=5B   29.315061=5D Call Trace:
=5B   29.316271=5D  =5B<ffffffff8116bfa2>=5D submit_page_section+0xb1/0x1=
14
=5B   29.317495=5D  =5B<ffffffff8116cad6>=5D do_blockdev_direct_IO+0xa28/=
0xd1f
=5B   29.318712=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   29.319938=5D  =5B<ffffffff8116cdfc>=5D __blockdev_direct_IO+0x2f/0x=
31
=5B   29.321162=5D  =5B<ffffffff8116cdfc>=5D ? __blockdev_direct_IO+0x2f/=
0x31
=5B   29.322366=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   29.323587=5D  =5B<ffffffff811698e2>=5D blkdev_direct_IO+0x2e/0x30
=5B   29.324789=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   29.325989=5D  =5B<ffffffff810f314c>=5D generic_file_read_iter+0x93/=
0x5c8
=5B   29.327217=5D  =5B<ffffffff81169c8a>=5D blkdev_read_iter+0x35/0x37
=5B   29.328421=5D  =5B<ffffffff81139725>=5D new_sync_read+0x74/0x98
=5B   29.329626=5D  =5B<ffffffff81139e0c>=5D vfs_read+0xce/0x124
=5B   29.330873=5D  =5B<ffffffff8113a665>=5D SyS_read+0x4b/0x79
=5B   29.332076=5D  =5B<ffffffff8167ea92>=5D system_call_fastpath+0x16/0x=
1b
=5B   29.333302=5D Code: fe ff ff 48 89 df e8 40 fe ff ff 48 c7 c7 f0 3c =
d1 81 85 c0 89 45 dc 0f 95 c3 31 d2 0f b6 f3 e8 4f ad f6 ff 84 db 8b 45 d=
c 74 02 <0f> 0b 5a 5b 41 5c 41 5d 41 5e 5d c3 55 48 89 e5 41 57 4d 89 cf =

=5B   29.334775=5D RIP  =5B<ffffffff8116bee5>=5D dio_send_cur_page+0xd7/0=
xe3
=5B   29.336131=5D  RSP <ffff8802226d7aa0>
=5B   29.337472=5D ---=5B end trace 5bdcfa6254e32468 =5D---
=5B   29.497496=5D ------------=5B cut here =5D------------
=5B   29.500042=5D WARNING: CPU: 3 PID: 421 at kernel/exit.c:669 do_exit+=
0x7c/0xc0c()
=5B   29.502559=5D Modules linked in:
=5B   29.505067=5D CPU: 3 PID: 421 Comm: systemd-cryptse Tainted: G      =
D W      3.16.0-rc4-next-20140707 =23247
=5B   29.507634=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B   29.510200=5D  0000000000000000 ffff8802226d77c0 ffffffff816737c4 00=
00000000000000
=5B   29.512660=5D  0000000000000009 ffff8802226d77f8 ffffffff8103d49f ff=
ffffff8103e22a
=5B   29.514888=5D  ffff88022245c310 000000000000000b 0000000000000001 00=
00000000000000
=5B   29.516872=5D Call Trace:
=5B   29.518841=5D  =5B<ffffffff816737c4>=5D dump_stack+0x51/0xaa
=5B   29.520813=5D  =5B<ffffffff8103d49f>=5D warn_slowpath_common+0x7a/0x=
93
=5B   29.522807=5D  =5B<ffffffff8103e22a>=5D ? do_exit+0x7c/0xc0c
=5B   29.524785=5D  =5B<ffffffff8103d55c>=5D warn_slowpath_null+0x15/0x17=

=5B   29.526753=5D  =5B<ffffffff8103e22a>=5D do_exit+0x7c/0xc0c
=5B   29.528670=5D  =5B<ffffffff81087e47>=5D ? __rcu_read_unlock+0xf2/0xf=
9
=5B   29.530619=5D  =5B<ffffffff81081c70>=5D ? kmsg_dump+0xb3/0xb9
=5B   29.532539=5D  =5B<ffffffff8100577f>=5D oops_end+0x7c/0x81
=5B   29.534452=5D  =5B<ffffffff81005ad1>=5D die+0x55/0x5e
=5B   29.536351=5D  =5B<ffffffff810029d3>=5D do_trap+0x64/0x11b
=5B   29.538246=5D  =5B<ffffffff81002b98>=5D do_error_trap+0xbe/0xcd
=5B   29.540126=5D  =5B<ffffffff8116bee5>=5D ? dio_send_cur_page+0xd7/0xe=
3
=5B   29.541961=5D  =5B<ffffffff810d6212>=5D ? time_hardirqs_off+0x1b/0x2=
f
=5B   29.543689=5D  =5B<ffffffff81680883>=5D ? error_sti+0x5/0x6
=5B   29.545359=5D  =5B<ffffffff8107734d>=5D ? trace_hardirqs_off_caller+=
0x1f/0xb9
=5B   29.546999=5D  =5B<ffffffff8127c96a>=5D ? trace_hardirqs_off_thunk+0=
x3a/0x3c
=5B   29.548594=5D  =5B<ffffffff810035e1>=5D do_invalid_op+0x1b/0x1d
=5B   29.550181=5D  =5B<ffffffff816803b8>=5D invalid_op+0x18/0x20
=5B   29.551750=5D  =5B<ffffffff8116bee5>=5D ? dio_send_cur_page+0xd7/0xe=
3
=5B   29.553333=5D  =5B<ffffffff8116bfa2>=5D submit_page_section+0xb1/0x1=
14
=5B   29.554912=5D  =5B<ffffffff8116cad6>=5D do_blockdev_direct_IO+0xa28/=
0xd1f
=5B   29.556483=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   29.558014=5D  =5B<ffffffff8116cdfc>=5D __blockdev_direct_IO+0x2f/0x=
31
=5B   29.559513=5D  =5B<ffffffff8116cdfc>=5D ? __blockdev_direct_IO+0x2f/=
0x31
=5B   29.561033=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   29.562483=5D  =5B<ffffffff811698e2>=5D blkdev_direct_IO+0x2e/0x30
=5B   29.563926=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   29.565354=5D  =5B<ffffffff810f314c>=5D generic_file_read_iter+0x93/=
0x5c8
=5B   29.566785=5D  =5B<ffffffff81169c8a>=5D blkdev_read_iter+0x35/0x37
=5B   29.568208=5D  =5B<ffffffff81139725>=5D new_sync_read+0x74/0x98
=5B   29.569629=5D  =5B<ffffffff81139e0c>=5D vfs_read+0xce/0x124
=5B   29.571044=5D  =5B<ffffffff8113a665>=5D SyS_read+0x4b/0x79
=5B   29.572418=5D  =5B<ffffffff8167ea92>=5D system_call_fastpath+0x16/0x=
1b
=5B   29.573781=5D ---=5B end trace 5bdcfa6254e32469 =5D---
=5B   31.004909=5D ------------=5B cut here =5D------------
=5B   31.006170=5D kernel BUG at fs/direct-io.c:747=21
=5B   31.007406=5D invalid opcode: 0000 =5B=234=5D PREEMPT SMP=20
=5B   31.008909=5D Modules linked in:
=5B   31.010468=5D CPU: 0 PID: 466 Comm: systemd-cryptse Tainted: G      =
D W      3.16.0-rc4-next-20140707 =23247
=5B   31.011924=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B   31.013227=5D task: ffff880222698590 ti: ffff8800c6f8c000 task.ti: f=
fff8800c6f8c000
=5B   31.015102=5D RIP: 0010:=5B<ffffffff8116bee5>=5D  =5B<ffffffff8116be=
e5>=5D dio_send_cur_page+0xd7/0xe3
=5B   31.017030=5D RSP: 0018:ffff8800c6f8faa0  EFLAGS: 00010202
=5B   31.018772=5D RAX: 0000000000000001 RBX: ffff8800c6f8fc01 RCX: 00000=
00000000000
=5B   31.020549=5D RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffff=
fff81d13cf0
=5B   31.022231=5D RBP: ffff8800c6f8fac8 R08: 0000000000000000 R09: 00000=
00000000001
=5B   31.024144=5D R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
800c6e8c080
=5B   31.026066=5D R13: ffff8800c6f8fbc0 R14: 000000000000007a R15: 00000=
0000000007c
=5B   31.027749=5D FS:  00007fc2b4bca840(0000) GS:ffff88022dc00000(0000) =
knlGS:0000000000000000
=5B   31.029323=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B   31.031043=5D CR2: 00007fb36a91a148 CR3: 00000000c6ef4000 CR4: 00000=
000001407f0
=5B   31.032810=5D Stack:
=5B   31.034113=5D  0000000100000000 ffff8800c6e8c080 ffffea0007826578 00=
00000000000800
=5B   31.035319=5D  ffff8800c6f8fc28 ffff8800c6f8fb08 ffffffff8116bfa2 00=
00000022110780
=5B   31.036493=5D  ffff8800c6e8c080 ffffea0007826578 0000000000000800 00=
00000000000001
=5B   31.037686=5D Call Trace:
=5B   31.038848=5D  =5B<ffffffff8116bfa2>=5D submit_page_section+0xb1/0x1=
14
=5B   31.040006=5D  =5B<ffffffff8116cad6>=5D do_blockdev_direct_IO+0xa28/=
0xd1f
=5B   31.041184=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   31.042321=5D  =5B<ffffffff8116cdfc>=5D __blockdev_direct_IO+0x2f/0x=
31
=5B   31.043459=5D  =5B<ffffffff8116cdfc>=5D ? __blockdev_direct_IO+0x2f/=
0x31
=5B   31.044615=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   31.045773=5D  =5B<ffffffff811698e2>=5D blkdev_direct_IO+0x2e/0x30
=5B   31.046906=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   31.048055=5D  =5B<ffffffff810f314c>=5D generic_file_read_iter+0x93/=
0x5c8
=5B   31.049220=5D  =5B<ffffffff81169c8a>=5D blkdev_read_iter+0x35/0x37
=5B   31.050376=5D  =5B<ffffffff81139725>=5D new_sync_read+0x74/0x98
=5B   31.051513=5D  =5B<ffffffff81139e0c>=5D vfs_read+0xce/0x124
=5B   31.052649=5D  =5B<ffffffff8113a665>=5D SyS_read+0x4b/0x79
=5B   31.053810=5D  =5B<ffffffff8167ea92>=5D system_call_fastpath+0x16/0x=
1b
=5B   31.054949=5D Code: fe ff ff 48 89 df e8 40 fe ff ff 48 c7 c7 f0 3c =
d1 81 85 c0 89 45 dc 0f 95 c3 31 d2 0f b6 f3 e8 4f ad f6 ff 84 db 8b 45 d=
c 74 02 <0f> 0b 5a 5b 41 5c 41 5d 41 5e 5d c3 55 48 89 e5 41 57 4d 89 cf =

=5B   31.056357=5D RIP  =5B<ffffffff8116bee5>=5D dio_send_cur_page+0xd7/0=
xe3
=5B   31.057627=5D  RSP <ffff8800c6f8faa0>
=5B   31.059350=5D ---=5B end trace 5bdcfa6254e3246a =5D---
=5B   34.326846=5D Call Trace:
=5B   34.328808=5D  =5B<ffffffff816737c4>=5D dump_stack+0x51/0xaa
=5B   34.330793=5D  =5B<ffffffff8103d49f>=5D warn_slowpath_common+0x7a/0x=
93
=5B   34.332772=5D  =5B<ffffffff8103e22a>=5D ? do_exit+0x7c/0xc0c
=5B   34.334755=5D  =5B<ffffffff8103d55c>=5D warn_slowpath_null+0x15/0x17=

=5B   34.336732=5D  =5B<ffffffff8103e22a>=5D do_exit+0x7c/0xc0c
=5B   34.338688=5D  =5B<ffffffff81087e47>=5D ? __rcu_read_unlock+0xf2/0xf=
9
=5B   34.340606=5D  =5B<ffffffff81081c70>=5D ? kmsg_dump+0xb3/0xb9
=5B   34.342598=5D  =5B<ffffffff8100577f>=5D oops_end+0x7c/0x81
=5B   34.344531=5D  =5B<ffffffff81005ad1>=5D die+0x55/0x5e
=5B   34.346459=5D  =5B<ffffffff810029d3>=5D do_trap+0x64/0x11b
=5B   34.348365=5D  =5B<ffffffff81002b98>=5D do_error_trap+0xbe/0xcd
=5B   34.350251=5D  =5B<ffffffff8116bee5>=5D ? dio_send_cur_page+0xd7/0xe=
3
=5B   34.352107=5D  =5B<ffffffff810d6212>=5D ? time_hardirqs_off+0x1b/0x2=
f
=5B   34.353884=5D  =5B<ffffffff81680883>=5D ? error_sti+0x5/0x6
=5B   34.355565=5D  =5B<ffffffff8107734d>=5D ? trace_hardirqs_off_caller+=
0x1f/0xb9
=5B   34.357209=5D  =5B<ffffffff8127c96a>=5D ? trace_hardirqs_off_thunk+0=
x3a/0x3c
=5B   34.358803=5D  =5B<ffffffff810035e1>=5D do_invalid_op+0x1b/0x1d
=5B   34.360410=5D  =5B<ffffffff816803b8>=5D invalid_op+0x18/0x20
=5B   34.361988=5D  =5B<ffffffff8116bee5>=5D ? dio_send_cur_page+0xd7/0xe=
3
=5B   34.363557=5D  =5B<ffffffff8116bfa2>=5D submit_page_section+0xb1/0x1=
14
=5B   34.365135=5D  =5B<ffffffff8116cad6>=5D do_blockdev_direct_IO+0xa28/=
0xd1f
=5B   34.366719=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   34.368233=5D  =5B<ffffffff8116cdfc>=5D __blockdev_direct_IO+0x2f/0x=
31
=5B   34.369732=5D  =5B<ffffffff8116cdfc>=5D ? __blockdev_direct_IO+0x2f/=
0x31
=5B   34.371205=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   34.372634=5D  =5B<ffffffff811698e2>=5D blkdev_direct_IO+0x2e/0x30
=5B   34.374047=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   34.375456=5D  =5B<ffffffff810f314c>=5D generic_file_read_iter+0x93/=
0x5c8
=5B   34.376903=5D  =5B<ffffffff81169c8a>=5D blkdev_read_iter+0x35/0x37
=5B   34.378344=5D  =5B<ffffffff81139725>=5D new_sync_read+0x74/0x98
=5B   34.379743=5D  =5B<ffffffff81139e0c>=5D vfs_read+0xce/0x124
=5B   34.381117=5D  =5B<ffffffff8113a665>=5D SyS_read+0x4b/0x79
=5B   34.382475=5D  =5B<ffffffff8167ea92>=5D system_call_fastpath+0x16/0x=
1b
=5B   34.383869=5D ---=5B end trace 5bdcfa6254e3246b =5D---
=5B   34.391634=5D systemd-cryptse (466) used greatest stack depth: 11824=
 bytes left
=5B   35.807507=5D ------------=5B cut here =5D------------
=5B   35.808859=5D kernel BUG at fs/direct-io.c:747=21
=5B   35.810240=5D invalid opcode: 0000 =5B=235=5D PREEMPT SMP=20
=5B   35.811614=5D Modules linked in:
=5B   35.812933=5D CPU: 2 PID: 512 Comm: systemd-cryptse Tainted: G      =
D W      3.16.0-rc4-next-20140707 =23247
=5B   35.814323=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
14 01/13/2014
=5B   35.815759=5D task: ffff880221424990 ti: ffff8800c6e70000 task.ti: f=
fff8800c6e70000
=5B   35.817199=5D RIP: 0010:=5B<ffffffff8116bee5>=5D  =5B<ffffffff8116be=
e5>=5D dio_send_cur_page+0xd7/0xe3
=5B   35.818617=5D RSP: 0018:ffff8800c6e73aa0  EFLAGS: 00010202
=5B   35.820242=5D RAX: 0000000000000001 RBX: ffff8800c6e73c01 RCX: 00000=
00000000000
=5B   35.821984=5D RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffff=
fff81d13cf0
=5B   35.823716=5D RBP: ffff8800c6e73ac8 R08: 0000000000000000 R09: 00000=
00000000001
=5B   35.825338=5D R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
80222bef640
=5B   35.826616=5D R13: ffff8800c6e73bc0 R14: 000000000000007a R15: 00000=
0000000007c
=5B   35.827901=5D FS:  00007fbf8b763840(0000) GS:ffff88022dd00000(0000) =
knlGS:0000000000000000
=5B   35.829187=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B   35.830483=5D CR2: 00000000006ecf18 CR3: 00000000c68be000 CR4: 00000=
000001407e0
=5B   35.831823=5D Stack:
=5B   35.833595=5D  0000000100000000 ffff880222bef640 ffffea0007829aa0 00=
00000000000800
=5B   35.836180=5D  ffff8800c6e73c28 ffff8800c6e73b08 ffffffff8116bfa2 00=
00000022110780
=5B   35.838734=5D  ffff880222bef640 ffffea0007829aa0 0000000000000800 00=
00000000000001
=5B   35.841297=5D Call Trace:
=5B   35.843832=5D  =5B<ffffffff8116bfa2>=5D submit_page_section+0xb1/0x1=
14
=5B   35.846382=5D  =5B<ffffffff8116cad6>=5D do_blockdev_direct_IO+0xa28/=
0xd1f
=5B   35.848917=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   35.851419=5D  =5B<ffffffff8116cdfc>=5D __blockdev_direct_IO+0x2f/0x=
31
=5B   35.853944=5D  =5B<ffffffff8116cdfc>=5D ? __blockdev_direct_IO+0x2f/=
0x31
=5B   35.856494=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   35.858997=5D  =5B<ffffffff811698e2>=5D blkdev_direct_IO+0x2e/0x30
=5B   35.861523=5D  =5B<ffffffff81169558>=5D ? I_BDEV+0xd/0xd
=5B   35.864076=5D  =5B<ffffffff810f314c>=5D generic_file_read_iter+0x93/=
0x5c8
=5B   35.866600=5D  =5B<ffffffff81169c8a>=5D blkdev_read_iter+0x35/0x37
=5B   35.869150=5D  =5B<ffffffff81139725>=5D new_sync_read+0x74/0x98
=5B   35.871701=5D  =5B<ffffffff81139e0c>=5D vfs_read+0xce/0x124
=5B   35.874223=5D  =5B<ffffffff8113a665>=5D SyS_read+0x4b/0x79
=5B   35.876750=5D  =5B<ffffffff8167ea92>=5D system_call_fastpath+0x16/0x=
1b
=5B   35.879271=5D Code: fe ff ff 48 89 df e8 40 fe ff ff 48 c7 c7 f0 3c =
d1 81 85 c0 89 45 dc 0f 95 c3 31 d2 0f b6 f3 e8 4f ad f6 ff 84 db 8b 45 d=
c 74 02 <0f> 0b 5a 5b 41 5c 41 5d 41 5e 5d c3 55 48 89 e5 41 57 4d 89 cf =

=5B   35.882360=5D RIP  =5B<ffffffff8116bee5>=5D dio_send_cur_page+0xd7/0=
xe3
=5B   35.885128=5D  RSP <ffff8800c6e73aa0>
=5B   35.887972=5D ---=5B end trace 5bdcfa6254e3246c =5D---


--==_Exmh_1404835247_1910P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU7wVrgdmEQWDXROgAQI92Q//ZFgq+odftkgW4gsitftZk3oMnHN1l94Y
IpceJSMyQXeqUYGbbhFY8Gzdu5/oQL0o/MjU/VLFBYe4eG5+1rVuEBbOGy0B4qj+
8Xb9NeWBRtmnO7ELQ29YkwejLjf/iJelzzGT7fAO0Ev4Ps4UAGvEh5vconTAinpS
1evnZtmMe9R6MZKpAVEuobzsQKhwYfS2eQweN1L8kwqGEMKJB0gUBJzG8zda+iDA
uijLMTvl/wfuLqMLdlF3cv3DQbepgh7Dl91sY52f/S17m6QwxIqbdrw1QdjacYUz
N7US0q0D73ui6lZUWzY9QViQNXY091wVWDA0SPjyZRjqYGOY85w1f99mLYMtLPyG
cDCRp4CEUTlKguBr1+vdJTwfQhCJ4D/LNrfxFIHHVFPNwUaUnEYMvDrMTwGmG227
UmGllxozbqrbmpT3o8ImQ2LfQMrpMeJg/rXz30Wi35lb8VQojhUIv/uB8z9I4AIP
sPZoRF65jMCKdcgT8pSnAxYM9kGmESu0SaXx04x3LtkTujnwkRlvDSbGIUIqMOOF
7WAldrprh5TaGC+tCVVjOMHYcvGntDYg2vXbPzHIACpzuGOHDAWiRCTKKI6fzHlr
MY8s34zx6TCLpSIOUrIzblVR5phjUQ6d3Q3dU5UU3O0/cq0RfjyB7P8Vksv2yhHA
jaaIs68SB/Q=
=xbLz
-----END PGP SIGNATURE-----

--==_Exmh_1404835247_1910P--

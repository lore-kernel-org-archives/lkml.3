Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3HEO1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:27:45 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:65273 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3HEO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:27:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130805132948.GA14942@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130805132948.GA14942@redhat.com>
Date: Mon, 5 Aug 2013 09:27:41 -0500
Message-ID: <CAMP44s0iXYjNuSqtCCjBHbbmmrYsKcrRBmD_W_nEiWTxPX1+xQ@mail.gmail.com>
Subject: Re: Linux 3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 8:29 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/04, Felipe Contreras wrote:
>>
>> I found a regression while running all v3.11-rcX kernels; Starcract II
>> through wine crashes.
>
> Thanks... just to clarify, Starcract crashes, wine or kernel?

It's Starcraft. In fact, it detects the crash and tries to send a bug
report to Blizzard, the company behind it.

>> The culprit is fab840f (ptrace: PTRACE_DETACH
>> should do flush_ptrace_hw_breakpoint(child)), I revert that commit and
>> there's no crash.
>
> I never used wine, but I am puzzled anyway. This patch really looks
> like a simple and minor bugfix.
>
> Could you please run wine under strace
>
>         strace -f -e ptrace -o LOG wine ...
>
> and show the result?

Sure. Note that the crash might have happened some time before the end
of the log.

951   +++ exited with 0 +++
952   +++ exited with 0 +++
950   --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=952,
si_status=0, si_utime=0, si_stime=0} ---
954   +++ exited with 0 +++
956   +++ exited with 0 +++
955   --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=956,
si_status=0, si_utime=0, si_stime=0} ---
958   +++ exited with 0 +++
955   --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=958,
si_status=0, si_utime=0, si_stime=0} ---
962   +++ exited with 0 +++
959   --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=962,
si_status=0, si_utime=0, si_stime=0} ---
961   +++ exited with 0 +++
970   +++ exited with 0 +++
959   --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=970,
si_status=0, si_utime=0, si_stime=0} ---
965   +++ exited with 0 +++
977   +++ exited with 0 +++
957   --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=977,
si_status=0, si_utime=0, si_stime=0} ---
955   +++ exited with 0 +++
950   --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=954,
si_status=0, si_utime=0, si_stime=0} ---
980   --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
988   +++ exited with 0 +++
986   --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=988,
si_status=0, si_utime=0, si_stime=0} ---
993   +++ exited with 0 +++
989   --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=993,
si_status=0, si_utime=0, si_stime=0} ---
995   +++ exited with 0 +++
992   +++ exited with 0 +++
989   +++ exited with 0 +++
1009  +++ exited with 0 +++
1010  +++ exited with 0 +++
1011  +++ exited with 0 +++
1012  +++ exited with 0 +++
1013  +++ exited with 0 +++
1014  +++ exited with 0 +++
1016  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1016  +++ exited with 0 +++
1018  +++ exited with 0 +++
1020  +++ exited with 0 +++
1021  +++ exited with 0 +++
1022  +++ exited with 0 +++
974   +++ exited with 0 +++
1023  +++ exited with 0 +++
1025  +++ exited with 0 +++
1005  --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=1025,
si_status=0, si_utime=0, si_stime=0} ---
1027  +++ exited with 0 +++
1029  +++ exited with 0 +++
980   +++ exited with 0 +++
986   +++ exited with 0 +++
1032  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1032  +++ exited with 0 +++
1034  +++ exited with 0 +++
1026  --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=1034,
si_status=0, si_utime=0, si_stime=0} ---
1036  +++ exited with 0 +++
983   +++ exited with 0 +++
984   +++ exited with 0 +++
991   +++ exited with 0 +++
1031  +++ exited with 0 +++
981   +++ exited with 0 +++
985   --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
982   +++ exited with 0 +++
985   +++ exited with 0 +++
987   +++ exited with 0 +++
990   +++ exited with 0 +++
1030  +++ exited with 0 +++
950   +++ exited with 0 +++
1033  +++ exited with 0 +++
1026  +++ exited with 0 +++
957   +++ exited with 0 +++
1037  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1041  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1047  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1049  +++ exited with 0 +++
1050  +++ exited with 0 +++
1051  +++ exited with 0 +++
1052  +++ exited with 0 +++
1053  +++ exited with 0 +++
1054  +++ exited with 0 +++
1028  +++ exited with 0 +++
1056  +++ exited with 0 +++
1057  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1060  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1061  +++ exited with 0 +++
1062  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1063  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1064  +++ exited with 0 +++
1066  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1067  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1067  +++ exited with 0 +++
1069  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1070  +++ exited with 0 +++
1071  +++ exited with 0 +++
1072  +++ exited with 0 +++
1073  +++ exited with 0 +++
1074  +++ exited with 0 +++
1075  +++ exited with 0 +++
1076  +++ exited with 0 +++
1077  +++ exited with 0 +++
1078  +++ exited with 0 +++
1079  +++ exited with 0 +++
1080  +++ exited with 0 +++
1081  +++ exited with 0 +++
1082  +++ exited with 0 +++
1087  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1086  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1091  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1093  +++ exited with 0 +++
1094  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1095  +++ exited with 0 +++
1096  +++ exited with 0 +++
1097  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1098  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1098  +++ exited with 0 +++
1099  +++ exited with 0 +++
1100  +++ exited with 0 +++
1101  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1101  +++ exited with 0 +++
1103  +++ exited with 0 +++
1104  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1105  +++ exited with 0 +++
1106  +++ exited with 0 +++
1107  +++ exited with 0 +++
1108  +++ exited with 0 +++
1109  +++ exited with 0 +++
1110  +++ exited with 0 +++
1111  +++ exited with 0 +++
1112  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1113  +++ exited with 0 +++
1114  +++ exited with 0 +++
1115  +++ exited with 0 +++
1116  +++ exited with 0 +++
1117  +++ exited with 0 +++
1122  +++ exited with 0 +++
1123  +++ exited with 0 +++
968   +++ exited with 0 +++
966   +++ exited with 0 +++
1124  +++ exited with 0 +++
1125  +++ exited with 0 +++
1126  +++ exited with 0 +++
1127  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1039  +++ exited with 0 +++
1128  +++ exited with 0 +++
1129  +++ exited with 0 +++
1130  +++ exited with 0 +++
1131  +++ exited with 0 +++
1132  +++ exited with 0 +++
1133  +++ exited with 0 +++
1134  +++ exited with 0 +++
998   +++ exited with 0 +++
1135  +++ exited with 0 +++
1136  +++ exited with 0 +++
1137  +++ exited with 0 +++
1138  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1141  +++ exited with 0 +++
1102  +++ exited with 0 +++
1142  +++ exited with 0 +++
1085  +++ exited with 0 +++
1143  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1002  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1087  +++ exited with 0 +++
1144  +++ exited with 0 +++
1084  +++ exited with 0 +++
1083  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
1145  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1147  +++ exited with 0 +++
1024  +++ exited with 0 +++
1148  +++ exited with 0 +++
1152  +++ exited with 0 +++
1006  --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=1152,
si_status=0, si_utime=0, si_stime=0} ---
1154  +++ exited with 0 +++
1156  +++ exited with 0 +++
1157  +++ exited with 0 +++
1158  +++ exited with 0 +++
1153  --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=1158,
si_status=0, si_utime=0, si_stime=0} ---
953   ptrace(PTRACE_ATTACH, 1153, 0, 0) = -1 EPERM (Operation not permitted)
1160  +++ exited with 0 +++
1161  +++ exited with 0 +++
1162  +++ exited with 0 +++
1164  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1164, 0, 0) = -1 EPERM (Operation not permitted)
1163  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1163, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1094  +++ exited with 0 +++
1167  +++ exited with 0 +++
1046  +++ exited with 0 +++
1042  +++ exited with 0 +++
1048  +++ exited with 0 +++
1035  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1035  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1035  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1035  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1035  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1035  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1035  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1035  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1038  --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1038  +++ exited with 0 +++
1040  +++ exited with 0 +++
1043  +++ exited with 0 +++
1044  +++ exited with 0 +++
1045  +++ exited with 0 +++
1055  +++ exited with 0 +++
1059  +++ exited with 0 +++
1065  +++ exited with 0 +++
1068  +++ exited with 0 +++
1146  +++ exited with 0 +++
1035  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1153, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1153, 0, 0) = -1 EPERM (Operation not permitted)
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1155  +++ exited with 0 +++
1173  +++ exited with 0 +++
1153  +++ exited with 0 +++
1159  --- SIGILL {si_signo=SIGILL, si_code=ILL_ILLOPN, si_addr=0x3d406bbe} ---
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1200  --- SIGSEGV {si_signo=SIGSEGV, si_code=SEGV_ACCERR,
si_addr=0x7dd8c14f} ---
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1201  +++ exited with 0 +++
1200  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1200, 0, 0) = -1 EPERM (Operation not permitted)
1199  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1199, 0, 0) = -1 EPERM (Operation not permitted)
1198  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1198, 0, 0) = -1 EPERM (Operation not permitted)
1197  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1197, 0, 0) = -1 EPERM (Operation not permitted)
1196  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1196, 0, 0) = -1 EPERM (Operation not permitted)
1195  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1195, 0, 0) = -1 EPERM (Operation not permitted)
1194  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1194, 0, 0) = -1 EPERM (Operation not permitted)
1193  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1193, 0, 0) = -1 EPERM (Operation not permitted)
1192  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1192, 0, 0) = -1 EPERM (Operation not permitted)
1191  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1191, 0, 0) = -1 EPERM (Operation not permitted)
1190  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1190, 0, 0) = -1 EPERM (Operation not permitted)
1189  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1189, 0, 0) = -1 EPERM (Operation not permitted)
1188  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1188, 0, 0) = -1 EPERM (Operation not permitted)
1187  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1187, 0, 0) = -1 EPERM (Operation not permitted)
1186  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1186, 0, 0) = -1 EPERM (Operation not permitted)
1185  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1185, 0, 0) = -1 EPERM (Operation not permitted)
1184  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1184, 0, 0) = -1 EPERM (Operation not permitted)
1183  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1183, 0, 0) = -1 EPERM (Operation not permitted)
1182  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1182, 0, 0) = -1 EPERM (Operation not permitted)
1181  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1181, 0, 0) = -1 EPERM (Operation not permitted)
1180  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1180, 0, 0) = -1 EPERM (Operation not permitted)
1179  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1179, 0, 0) = -1 EPERM (Operation not permitted)
1178  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1178, 0, 0) = -1 EPERM (Operation not permitted)
1177  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1177, 0, 0) = -1 EPERM (Operation not permitted)
1176  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1176, 0, 0) = -1 EPERM (Operation not permitted)
1175  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1175, 0, 0) = -1 EPERM (Operation not permitted)
1174  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1174, 0, 0) = -1 EPERM (Operation not permitted)
1172  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1172, 0, 0) = -1 EPERM (Operation not permitted)
1171  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1171, 0, 0) = -1 EPERM (Operation not permitted)
1170  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1170, 0, 0) = -1 EPERM (Operation not permitted)
1169  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1169, 0, 0) = -1 EPERM (Operation not permitted)
1168  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1168, 0, 0) = -1 EPERM (Operation not permitted)
1166  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1166, 0, 0) = -1 EPERM (Operation not permitted)
1165  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1165, 0, 0) = -1 EPERM (Operation not permitted)
1164  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1164, 0, 0) = -1 EPERM (Operation not permitted)
1163  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1163, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1200  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1199  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1198  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1197  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1196  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1195  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1194  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1193  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1192  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1191  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1190  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1189  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1188  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1187  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1186  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1185  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1184  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1183  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1182  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1181  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1180  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1179  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1178  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1177  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1176  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1175  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1174  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1172  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1171  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1170  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1169  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1168  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1166  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1165  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1164  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1163  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1200, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1199, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1198, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1197, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1196, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1195, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1194, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1193, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1192, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1191, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1190, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1189, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1188, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1187, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1186, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1185, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1184, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1183, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1182, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1181, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1180, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1179, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1178, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1177, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1176, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1175, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1174, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1172, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1171, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1170, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1169, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1168, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1166, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1165, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1164, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1163, 0, 0) = -1 EPERM (Operation not permitted)
1200  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1200, 0, 0) = -1 EPERM (Operation not permitted)
1199  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1199, 0, 0) = -1 EPERM (Operation not permitted)
1198  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1198, 0, 0) = -1 EPERM (Operation not permitted)
1197  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1197, 0, 0) = -1 EPERM (Operation not permitted)
1196  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1196, 0, 0) = -1 EPERM (Operation not permitted)
1195  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1195, 0, 0) = -1 EPERM (Operation not permitted)
1194  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1194, 0, 0) = -1 EPERM (Operation not permitted)
1193  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1193, 0, 0) = -1 EPERM (Operation not permitted)
1192  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1192, 0, 0) = -1 EPERM (Operation not permitted)
1191  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1191, 0, 0) = -1 EPERM (Operation not permitted)
1190  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1190, 0, 0) = -1 EPERM (Operation not permitted)
1189  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1189, 0, 0) = -1 EPERM (Operation not permitted)
1188  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1188, 0, 0) = -1 EPERM (Operation not permitted)
1187  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1187, 0, 0) = -1 EPERM (Operation not permitted)
1186  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1186, 0, 0) = -1 EPERM (Operation not permitted)
1185  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1185, 0, 0) = -1 EPERM (Operation not permitted)
1184  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1184, 0, 0) = -1 EPERM (Operation not permitted)
1183  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1183, 0, 0) = -1 EPERM (Operation not permitted)
1182  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1182, 0, 0) = -1 EPERM (Operation not permitted)
1181  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1181, 0, 0) = -1 EPERM (Operation not permitted)
1180  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1180, 0, 0) = -1 EPERM (Operation not permitted)
1179  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1179, 0, 0) = -1 EPERM (Operation not permitted)
1178  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1178, 0, 0) = -1 EPERM (Operation not permitted)
1177  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1177, 0, 0) = -1 EPERM (Operation not permitted)
1176  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1176, 0, 0) = -1 EPERM (Operation not permitted)
1175  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1175, 0, 0) = -1 EPERM (Operation not permitted)
1174  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1174, 0, 0) = -1 EPERM (Operation not permitted)
1172  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1172, 0, 0) = -1 EPERM (Operation not permitted)
1171  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1171, 0, 0) = -1 EPERM (Operation not permitted)
1170  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1170, 0, 0) = -1 EPERM (Operation not permitted)
1169  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1169, 0, 0) = -1 EPERM (Operation not permitted)
1168  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1168, 0, 0) = -1 EPERM (Operation not permitted)
1166  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1166, 0, 0) = -1 EPERM (Operation not permitted)
1165  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1165, 0, 0) = -1 EPERM (Operation not permitted)
1164  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1164, 0, 0) = -1 EPERM (Operation not permitted)
1163  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1163, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1204  +++ exited with 0 +++
1202  +++ exited with 0 +++
1203  +++ exited with 0 +++
1207  +++ exited with 0 +++
1205  +++ exited with 0 +++
1206  +++ exited with 0 +++
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1200  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1200, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1199  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1199, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1198  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1198, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1197  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1197, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1196  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1196, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1195  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1195, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1194  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1194, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1193  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1193, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1192  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1192, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1191  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1191, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1190  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1190, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1189  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1189, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1188  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1188, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1187  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1187, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1186  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1186, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1185  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1185, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1184  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1184, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1183  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1183, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1182  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1182, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1181  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1181, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1180  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1180, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1179  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1179, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1178  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1178, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1177  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1177, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1176  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1176, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1175  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1175, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1174  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1174, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1172  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1172, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1171  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1171, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1170  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1170, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1169  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1169, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1168  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1168, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1166  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1166, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1165  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1165, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1163  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1163, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1159  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
953   ptrace(PTRACE_ATTACH, 1159, 0, 0) = -1 EPERM (Operation not permitted)
1208  +++ exited with 0 +++
1159  --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=1208,
si_status=0, si_utime=0, si_stime=0} ---
1163  +++ exited with 0 +++
1164  +++ exited with 0 +++
1165  +++ exited with 0 +++
1166  +++ exited with 0 +++
1169  --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1168  +++ exited with 0 +++
1169  +++ exited with 0 +++
1170  +++ exited with 0 +++
1171  +++ exited with 0 +++
1172  +++ exited with 0 +++
1174  +++ exited with 0 +++
1175  +++ exited with 0 +++
1176  +++ exited with 0 +++
1178  +++ exited with 0 +++
1180  +++ exited with 0 +++
1177  +++ exited with 0 +++
1179  +++ exited with 0 +++
1181  +++ exited with 0 +++
1182  +++ exited with 0 +++
1183  +++ exited with 0 +++
1184  --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1184  +++ exited with 0 +++
1185  +++ exited with 0 +++
1186  +++ exited with 0 +++
1187  +++ exited with 0 +++
1188  +++ exited with 0 +++
1189  +++ exited with 0 +++
1190  +++ exited with 0 +++
1191  +++ exited with 0 +++
1192  +++ exited with 0 +++
1193  +++ exited with 0 +++
1194  +++ exited with 0 +++
1195  +++ exited with 0 +++
1196  +++ exited with 0 +++
1197  +++ exited with 0 +++
1198  +++ exited with 0 +++
1199  +++ exited with 0 +++
1200  +++ exited with 0 +++
1159  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1210  --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1210  +++ exited with 0 +++
1209  +++ exited with 0 +++
1000  +++ exited with 0 +++
1150  +++ exited with 0 +++
1151  +++ exited with 0 +++
1007  +++ exited with 0 +++
1003  +++ exited with 0 +++
1004  +++ exited with 0 +++
1005  +++ exited with 0 +++
1006  +++ exited with 0 +++
1008  +++ exited with 0 +++
1058  +++ exited with 0 +++
1015  +++ exited with 0 +++
1017  +++ exited with 0 +++
1019  +++ exited with 0 +++
1001  +++ exited with 0 +++
996   +++ exited with 0 +++
1092  +++ exited with 0 +++
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1090  --- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1088  +++ exited with 0 +++
1090  +++ exited with 0 +++
1140  +++ exited with 0 +++
1139  +++ exited with 0 +++
1089  +++ exited with 0 +++
997   +++ exited with 0 +++
999   +++ exited with 0 +++
1212  --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
1211  +++ exited with 0 +++
1212  +++ exited with 0 +++
994   +++ exited with 0 +++
979   +++ exited with 0 +++
978   +++ exited with 0 +++
976   +++ exited with 0 +++
975   --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
975   +++ exited with 0 +++
971   +++ exited with 0 +++
967   --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
969   +++ exited with 0 +++
972   --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
967   +++ exited with 0 +++
972   +++ exited with 0 +++
973   +++ exited with 0 +++
963   +++ exited with 0 +++
964   --- SIGQUIT {si_signo=SIGQUIT, si_code=SI_TKILL, si_pid=953,
si_uid=1000} ---
960   +++ exited with 0 +++
964   +++ exited with 0 +++
1149  +++ exited with 0 +++
1213  +++ exited with 0 +++
1214  +++ exited with 0 +++
1215  +++ exited with 0 +++
959   +++ exited with 0 +++
953   +++ exited with 0 +++

-- 
Felipe Contreras

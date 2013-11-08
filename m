Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3KHINV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:13:21 -0500
Received: from intranet.asianux.com ([58.214.24.6]:24689 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3KHINT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:13:19 -0500
X-Spam-Score: -100.8
Message-ID: <527C9D9B.8090802@asianux.com>
Date: Fri, 08 Nov 2013 16:15:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
CC: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] kernel: cgroup: mount failure in LTP cgroup_regression_test.sh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

On Fedora16 with defconfig for next-20131107 kernel, use latest LTP
(Linux Test Project) version, test_5() in cgroup_regression_test.sh
will be fail. The related LTP output:

  <<<test_start>>>
  tag=cgroup stime=1383562810
  cmdline="       cgroup_regression_test.sh"
  contacts=""
  analysis=exit
  <<<test_output>>>
  cgroup_regression_test    1  TPASS  :  no kernel bug was found
  /opt/ltp/testcases/bin/cgroup_regression_test.sh: line 118: 13283 Terminated              ./fork_processes
  cgroup_regression_test    2  TPASS  :  notify_on_release is inherited
  cgroup_regression_test    3  TCONF  :  CONFIG_SCHED_DEBUG is not enabled
  cgroup_regression_test    4  TCONF  :  CONFIG_LOCKDEP is not enabled
  mount: xxx already mounted or cgroup/ busy
  cgroup_regression_test    5  TFAIL  :  mount freezer and cpuacct failed
  cgroup_regression_test    6  TCONF  :  CONFIG_CGROUP_NS
  /opt/ltp/testcases/bin/cgroup_regression_test.sh: line 360: 24428 Terminated              sleep 100 < cgroup/0
  /opt/ltp/testcases/bin/cgroup_regression_test.sh: line 381: 24447 Terminated              sleep 100 < cgroup/0
  cgroup_regression_test    7  TPASS  :  no kernel bug was found
  cgroup_regression_test    8  TPASS  :  no kernel bug was found
  cgroup_regression_test    9  TPASS  :  no kernel warning was found
  rmdir: failed to remove `cgroup/0': No such file or directory
  umount: /sys/fs/cgroup/systemd: device is busy.
          (In some cases useful info about processes that use
           the device is found by lsof(8) or fuser(1))
  cgroup_regression_test   10  TPASS  :  no kernel warning was found
  <<<execution_status>>>
  initiation_status="ok"
  duration=62 termination_type=exited termination_id=1 corefile=no
  cutime=3341 cstime=6353
  <<<test_end>>>

After simplify, the related operation, environments and output are:

  [root@gchenlinux tmp]# df -Th | grep cgroup
  tmpfs                             tmpfs    1001M     0 1001M   0% /sys/fs/cgroup
  [root@gchenlinux tmp]# lsof | grep cgroup | grep -v grep
  systemd       1          root    6r      DIR               0,18         0       5998 /sys/fs/cgroup/systemd/system
  [root@gchenlinux tmp]# cat /proc/cgroups 
  #subsys_name	hierarchy	num_cgroups	enabled
  cpuset	3	4	1
  cpu	4	35	1
  cpuacct	4	35	1
  freezer	5	4	1
  [root@gchenlinux tmp]# mkdir cgroup
  [root@gchenlinux tmp]# mount -t cgroup -o freezer,cpuacct xxx cgroup/
  mount: xxx already mounted or cgroup/ busy

Is it real issue of cgroup? If it is, I will/should continue analyzing.


Welcome any additional suggestions and completions.

Thanks.
--
Chen Gang

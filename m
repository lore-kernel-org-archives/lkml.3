Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3L0OfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 09:35:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab3L0OfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 09:35:18 -0500
Date: Fri, 27 Dec 2013 14:34:49 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Kashyap Chamarthy <kchamart@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Gleb Natapov <gleb@kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
Message-ID: <20131227143449.GN28747@redhat.com>
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com>
 <CAKohpomqHApogDEXA5LyWk-+B-Y1mwNQ63-wL3PPGz64s_3Dmw@mail.gmail.com>
 <20131227122422.62857cec@alan.etchedpixels.co.uk>
 <20131227124749.GE10961@minantech.com>
 <CA+5PVA60GSC0tTLJWLtVqb5eTPMzrszxtoBnUP8B_Q_60=oGyw@mail.gmail.com>
 <52BD8B8B.1050209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BD8B8B.1050209@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably the qemu command line is more interesting, which is in this
comment and reproduced below.

https://bugzilla.redhat.com/show_bug.cgi?id=1046317#c1

/usr/bin/qemu-kvm \
    -global virtio-blk-pci.scsi=off \
    -nodefconfig \
    -enable-fips \
    -nodefaults \
    -display none \
    -machine accel=kvm:tcg \
    -cpu host,+kvmclock \
    -m 500 \
    -no-reboot \
    -no-hpet \
    -kernel /var/tmp/.guestfs-0/kernel.32370 \
    -initrd /var/tmp/.guestfs-0/initrd.32370 \
    -device virtio-scsi-pci,id=scsi \
    -drive file=/tmp/libguestfswnVOx7/scratch.1,cache=unsafe,format=raw,id=hd0,if=none \
    -device scsi-hd,drive=hd0 \
    -drive file=/var/tmp/.guestfs-0/root.32370,snapshot=on,id=appliance,cache=unsafe,if=none \
    -device scsi-hd,drive=appliance \
    -device virtio-serial-pci \
    -serial stdio \
    -device sga \
    -chardev socket,path=/tmp/libguestfswnVOx7/guestfsd.sock,id=channel0 \
    -device virtserialport,chardev=channel0,name=org.libguestfs.channel.0 \
    -append 'panic=1 console=ttyS0 udevtimeout=600 no_timer_check acpi=off printk.time=1 cgroup_disable=memory root=/dev/sdb selinux=0 guestfs_verbose=1 TERM=screen'

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Fedora Windows cross-compiler. Compile Windows programs, test, and
build Windows installers. Over 100 libraries supported.
http://fedoraproject.org/wiki/MinGW

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaCYWnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:43:02 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41732 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755315AbaCYWm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:42:58 -0400
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2014 18:42:58 EDT
X-Sasl-enc: t3TGdWl69mDMrP0KzcJQvjOdDQ436adRsRTf+Wh+6fzx 1395786873
Date: Tue, 25 Mar 2014 14:24:17 -0700
From: Greg KH <greg@kroah.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Subject: Re: Feb. Fedora Kernel Patch Report
Message-ID: <20140325212417.GA6545@kroah.com>
References: <CA+5PVA6dz2ixLfHOHytkis6XmxdLKXZp9x8rEjB=pedrg7sXJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6dz2ixLfHOHytkis6XmxdLKXZp9x8rEjB=pedrg7sXJQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 10:13:29AM -0500, Josh Boyer wrote:
> It's been a while since I sent one of these.  Mostly that's due to the
> overlap between which upstream stable version we're using in Fedora
> across the releases, and how fast those have been happening upstream.
> We're settled on 3.13.y now, and with 3.14-rc4 out there things have
> calmed down enough to take stock again.
> 
> Here's the patches we have on top of 3.13.5.
> 
> josh
> 
> fs-proc-devtree-remove_proc_entry.patch
> - Upstream commit c1d867a54d426b45da017fbe8e585f8a3064ce8d

Now added.

> 
> drm-radeon-Disable-writeback-by-default-on-ppc.patch
> - This is superseded by upstream commit
> ea31bf697d27270188a93cd78cf9de4bc968aca3 but that seems to be a bit
> big for a stable backport

Yes too big.

> 
> dm-cache-policy-mq_fix-large-scale-table-allocation-bug.patch (rhbz 993744)
> - Still pending upstream (no idea why...)
> 
> sunrpc-create-a-new-dummy-pipe-for-gssd-to-hold-open.patch
> sunrpc-replace-gssd_running-with-more-reliable-check.patch
> nfs-check-gssd-running-before-krb5i-auth.patch
> - Added to fix a 15sec mount delay
> - Upstream commits 4b9a445e3eeb8bd9278b1ae51c1b3a651e370cd6
>   89f842435c630f8426f414e6030bc2ffea0d6f81
>   6aa23d76a7b549521a03b63b6d5b7880ea87eab7 respectively
> 
> rpc_pipe-remove-the-clntXX-dir-if-creating-the-pipe-fails.patch
> sunrpc-add-an-info-file-for-the-dummy-gssd-pipe.patch
> rpc_pipe-fix-cleanup-of-dummy-gssd-directory-when-notification-fails.patch
> - Fixes for some of the patches above (rhbz 1037793)
> - Upstream commits 3396f92f8be606ea485b0a82d4e7749a448b013b
>   e2f0c83a9de331d9352185ca3642616c13127539
>   23e66ba97127ff3b064d4c6c5138aa34eafc492f respectively


This seems like a new feature, which I'll not add to -stable trees.

> 
> elantech-Properly-differentiate-between-clickpads-an.patch (rhbz 1030802)
> - Upstream commit c15bdfd5b9831e4cab8cfc118243956e267dd30e

added

> 
> KVM-MMU-handle-invalid-root_hpa-at-__direct_map.patch (rhbz 924916)
> - Upstream commit 989c6b34f6a9480e397b170cc62237e89bf4fdb9
> - Probably should grab 37f6a4e237303549c8676dfe1fd1991ceab512eb too

Nice ones, if only the kvm developers would mark things for stable...

> 
> KVM-VMX-fix-use-after-free-of-vmx-loaded_vmcs.patch (rhbz 1047892)
> - Upstream commit 26a865f4aa8e66a6d94958de7656f7f1b03c6c56

applied.

> 
> 0001-Input-wacom-make-sure-touch_max-is-set-for-touch-dev.patch
> 0002-Input-wacom-add-support-for-three-new-Intuos-devices.patch
> 0003-Input-wacom-add-reporting-of-SW_MUTE_DEVICE-events.patch
> - rhbz 1003167 1046238
> - Upstream commits 1d0d6df02750b4a6f466768cbfbf860e24f4c8d4
>   b5fd2a3e92ca5c8c1f3c20d31ac5daed3ec4d604
>   961794a00eab03f4344b7d5e825e8e789e55da87

Applied.

> Input-ALPS-add-support-for-Dolphin-devices.patch (rhbz 953211)
> - Upstream commit ee65d4b36de8ddf4467f788faa5d8ddd1bfcdaa2

Too big for stable :(

> xhci-fix-resume-issues-on-renesas-chips-in-samsung-laptops.patch (rhbz 950630)
> - Upstream commit 1aa9578c1a9450fb21501c4f549f5b1edb557e6d
> - Oddly not queued for stable?

Someone marked it incorrectly :(

> cgroup-fixes.patch (rhbz 1045755)
> - Upstream commits 0ab02ca8f887908152d1a96db5130fc661d36a1e
> - There was a 3.12 version of this patch sent to stable list from
> Michal Hocko.  I don't remember why it wasn't applied, or why it
> wasn't applied for 3.13.y...

It didn't apply to 3.13, and I think I was waiting for a backported
version, do you have one?

> ipv6-introduce-IFA_F_NOPREFIXROUTE-and-IFA_F_MANAGETEMPADDR-flags.patch
> ipv6-addrconf-revert-if_inet6ifa_flag-format.patch
> - rhbz 1064430 1056711
> - Backports of commits to add this stuff in 3.14.  Not suitable for stable.
> 
> cifs-ensure-that-uncached-writes-handle-unmapped-areas-correctly.patch
> cifs-sanity-check-length-of-data-to-send-before-sending.patch
> cifs-mask-off-top-byte-in-get_rfc1002_length.patch
> - rhbz 1064253 CVE-2014-0069 rhbz 1068862
> - Upstream commit 5d81de8e8667da7135d3a32a964087c0faf5483f and two
> additional fixes

In the last release.

> 
> cpufreq-powernow-k8-Initialize-per-cpu-data-structures-properly.patch
> (rhbz 1054408)
> - Upstream commit c3274763bfc3bf1ececa269ed6e6c4d7ec1c3e5e
> - CC'd to stable but not queued

Had to wait a release.

> e100-Fix-disabling-already-disabled-device-warning.patch (rhbz 994438)
> - Upstream commit 2b6e0ca175fe4a20f21ba82b1e7ccc71029c4dd4

Now added.

Thanks so much for this breakdown, much appreciated.

greg k-h

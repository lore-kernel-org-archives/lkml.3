Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaCVCbC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 22:31:02 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:16715 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaCVCa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 22:30:57 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTyOXSKL2e
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.13 072/149] ACPI / resources: ignore invalid ACPI device resources
Date: Sat, 22 Mar 2014 02:30:43 +0000
User-Agent: KMail/1.13.7 (Linux/3.13-6.slh.2-aptosid-686; KDE/4.8.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
References: <20140321000436.377902063@linuxfoundation.org> <20140321000439.452672105@linuxfoundation.org>
In-Reply-To: <20140321000439.452672105@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201403220230.49584.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 21 March 2014, Greg Kroah-Hartman wrote:
> 3.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Zhang Rui <rui.zhang@intel.com>
> 
> commit b355cee88e3b1a193f0e9a81db810f6f83ad728b upstream.
> 
> ACPI table may export resource entry with 0 length.
> But the current code interprets this kind of resource in a wrong way.
> It will create a resource structure with
> res->end = acpi_resource->start + acpi_resource->len - 1;
> 
> This patch fixes a problem on my machine that a platform device fails
> to be created because one of its ACPI IO resource entry (start = 0,
> end = 0, length = 0) is translated into a generic resource with
> start = 0, end = 0xffffffff.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

This patch should probably be dropped from -stable (3.13 and 3.10) for 
the time being, it causes this warning:

pnp 00:01: unknown resource type 4 in _CRS
pnp 00:01: can't evaluate _CRS: 1

on all systems I've tested it on so far (~12 systems of vastly varying 
components and age, covering amd64 and i386).

This also seems to affect others as well:
	http://www.spinics.net/lists/linux-acpi/msg49431.html
	http://www.spinics.net/lists/linux-acpi/msg49438.html

Regards
	Stefan Lippers-Hollmann

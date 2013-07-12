Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3GLCj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:39:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58807 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab3GLCj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:39:56 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51DF6C5D.1020904@jp.fujitsu.com>
Date: Fri, 12 Jul 2013 11:39:25 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: dyoung@redhat.com
CC: airlied@linux.ie, vgoyal@redhat.com, bhe@redhat.com, chaowang@redhat.com,
        linux-kernel@vger.kernel.org, ishii.hironobu@jp.fujitsu.com
Subject: Re: PCIE resetting graphic card
References: <51DF6446.9090105@redhat.com>
In-Reply-To: <51DF6446.9090105@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

(2013/07/12 11:04), Dave Young wrote:
> Hi, Takao
> 
> I know you are working on the PCIE resetting patches for the iommu kdump
> issue.
> 
> You explicitly excluded the graphic card in your patch. I have some
> questions about this. Why can't we reset the graphic card like other
> pcie devices?

As far as I tested, the monitor blacks out after video controller is
reset, and we cannot know what's going on. So, for now display device is
not reset in my patch.

I'm not sure what we need to do to recover graphic card after its reset,
but my colleague said that we need to run BIOS code to get back legacy
VGA mode after reset. It seems not to be easy:-(

Maybe this document is helpful to do this.
http://www.coreboot.org/images/2/2b/Vgabios.pdf

Thanks,
Takao Indoh

> 
> We have problems, if 1st kernel is in kms mode kdump kernel will have no
> chance to switch back to VGA console. There's no serial port on most of
> recent laptops thus it's difficult to debug kdump issue.
> 
> So if we can reset graphic card as well, and if it works I wonder if the
> 2nd kdump kernel can use vga console with nomodeset?




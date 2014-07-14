Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaGNHih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:38:37 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:42598 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752724AbaGNHib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:38:31 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2014 03:38:31 EDT
Message-ID: <53C388F1.10606@daenzer.net>
Date: Mon, 14 Jul 2014 16:38:25 +0900
From: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Oded Gabbay <oded.gabbay@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: Andrew Lewycky <Andrew.Lewycky@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes
 in KV
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.2014 06:50, Oded Gabbay wrote:
> @@ -5876,8 +5871,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib)
>   */
>  int cik_vm_init(struct radeon_device *rdev)
>  {
> -	/* number of VMs */
> -	rdev->vm_manager.nvm = 16;
> +	/*
> +	 * number of VMs
> +	 * VMID 0 is reserved for Graphics
> +	 * radeon compute will use VMIDs 1-7
> +	 * KFD will use VMIDs 8-15
> +	 */
> +	rdev->vm_manager.nvm = 8;

This comment is inaccurate: Graphics can use VMIDs 1-7 as well.


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer

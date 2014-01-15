Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaAOQdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:33:13 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:65492 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaAOQdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:33:11 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssVY9SQsClBrtp5eFYXU7YfNKMAfocpEeot7SjdQ==
X-RZG-CLASS-ID: mo00
Date: Wed, 15 Jan 2014 17:33:04 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140115163304.GA31066@aepfle.de>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389728116-21337-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, K. Y. Srinivasan wrote:

> +static int hv_start_fcopy(struct hv_start_fcopy *smsg)

> +	if (access((char *)smsg->path_name, F_OK)) {
> +		if (smsg->copy_flags & CREATE_PATH) {
> +			if (mkdir((char *)smsg->path_name, 0755)) {

KY,

I guess this needs a loop over every path compoment to implement
'mkdir -p', if the "-CreateFullPath" option is used?

Hopefully "-DestinationPath" is an arbitrary string and does not require
some sort of C: prefix. ;-)


Olaf

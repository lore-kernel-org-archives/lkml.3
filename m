Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaLCQvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:51:09 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42604 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaLCQvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:51:07 -0500
MIME-Version: 1.0
In-Reply-To: <1417470961-16524-1-git-send-email-jilaiw@codeaurora.org>
References: <1417470961-16524-1-git-send-email-jilaiw@codeaurora.org>
Date: Wed, 3 Dec 2014 11:51:06 -0500
Message-ID: <CAF6AEGuoLy_UgPM_vBmUoN8iW4SURTFzbb9OkN=LwQc=PckxDg@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/msm/hdmi: add hdmi hdcp support
From: Rob Clark <robdclark@gmail.com>
To: Jilai Wang <jilaiw@codeaurora.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 4:56 PM, Jilai Wang <jilaiw@codeaurora.org> wrote:
> +               /* Enable HDCP Encryption */
> +               hdmi_write(hdmi, REG_HDMI_HDCP_CTRL, BIT(0) | BIT(8));

btw, as Bjron mentioned, there are a lot of these open coded BIT(n)..
but from a quick check, the first two or three I looked at, we already
have the appropriate defines in the rnndb generated headers, to
instead do:

        /* Enable HDCP Encryption */
        hdmi_write(hdmi, REG_HDMI_HDCP_CTRL,
                HDMI_HDCP_CTRL_ENABLE |
                HDMI_HDCP_CTRL_ENCRYPTION_ENABLE);

that seems somewhat more readable to me ;-)

BR,
-R

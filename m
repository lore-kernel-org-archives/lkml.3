Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab3LIUpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:45:04 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37021 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab3LIUo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6xSYq=7AfFm+qNLGSfe6qjaGKyrwxdpG_CXHSy2uVX_w@mail.gmail.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-3-git-send-email-yinghai@kernel.org>
	<CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
	<CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
	<CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
	<CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>
	<CAErSpo6xSYq=7AfFm+qNLGSfe6qjaGKyrwxdpG_CXHSy2uVX_w@mail.gmail.com>
Date: Mon, 9 Dec 2013 12:44:58 -0800
X-Google-Sender-Auth: 3J-bbb8T1tM-UG5o2XOkAAiVXro
Message-ID: <CAE9FiQVc=knLngJ9=oAi9NP4AQzu5hWGh_mkxsB2TqD_posL8g@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 12:20 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> Yes, I agree.  I didn't say it would be simple.  The quick fix would
> be easy for now, but adding nonsensical code makes our lives harder
> long into the future.

If the old kernel is working, and user update kernel then we should
not request them to append "pci=realloc=off" for booting.

other user that would have "pci=realloc=on" works, they could always
keep that.

For now, we just reduce auto enable scope, as very beginning we are doing
that esp for SRIOV..., and now SRIOV would require huge range esp when
num_VF could be 64. we are easy to hit the case that realloc code mess up
the bios allocation when there is not above 4G 64bit mmio.

Yinghai

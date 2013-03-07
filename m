Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab3CGO4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:56:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3CGO4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:56:06 -0500
Date: Thu, 7 Mar 2013 08:56:01 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Problem mounting efivarfs in 3.9
Message-ID: <20130307145601.GA24233@thinkpad-t410>
Mail-Followup-To: Matt Fleming <matt.fleming@intel.com>,
	linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
	stable@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

I found myself unable to mount efivarfs on one of my machines in 3.9.
This is due to your patch to be more aggressive about validating
filenames. This machine had some crash dumps from pstore, which start
with "dump-type". However now efivars expects the guid to follow the
first '-' character, despite the fact that the efivars pstore code is
creating the file names starting with dump-type. Since these names fail
the validation the mount fails.

These changes are now in some of the stable releases as well (3.8.x at
minumum).

Thanks,
Seth

